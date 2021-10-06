//
//  AppDelegate.swift
//  CryptoCurrencyTestApp
//
//  Created by Aba-Bakri Ibragimov on 1/10/21.
//

import UIKit
import Charts
import Starscream

struct CryptoDateModel {
    let period_id: String
    let startDate: String
    let endDate: String
}

class MainViewController: UIViewController {
    
    @IBOutlet private weak var symbolView: UIView! {
        didSet {
            symbolView.layer.cornerRadius = 8
            symbolView.layer.borderWidth = 2
            symbolView.layer.borderColor = UIColor.black.cgColor
            let gesture = UITapGestureRecognizer(target: self, action: #selector (self.searchCryptoSymbols))
            symbolView.addGestureRecognizer(gesture)
        }
    }
    @IBOutlet private weak var symbolViewLabel: UILabel!
    @IBOutlet private weak var symbolLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var chartView: LineChartView!
    @IBOutlet private weak var marketDataView: UIView! {
        didSet {
            marketDataView.layer.cornerRadius = 8
            marketDataView.layer.borderWidth = 2
            marketDataView.layer.borderColor = UIColor.black.cgColor
        }
    }
    
    var viewModel = MainViewModel()
    var socket: WebSocket!
    var isConnected = false
    let server = WebSocketServer()
    var timer: Timer? = nil
    
    var symbol_id: String = "BINANCE_SPOT_BTC_USDT"
    
    var visitors: [Double] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chartView.rightAxis.enabled = false
        chartView.xAxis.enabled = false
        getSymbolsBySymbolId(symbol_id: symbol_id, exchange_id: "BINANCE")
        getHistoryLatestData(symbol_id: symbol_id)
        socketConnect()
    }
    
    func socketConnect() {
        var request = URLRequest(url: URL(string: Constants.surl)!)
        request.timeoutInterval = 60
        socket = WebSocket(request: request)
        socket.delegate = self
        socket.connect()
    }
    
    private func getHistoryLatestData(symbol_id: String) {
        self.showActivityIndicator()
        viewModel.getHistoryLatestData(symbol_id: symbol_id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.addDataChart(data: response)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    private func getSymbolsBySymbolId(symbol_id: String, exchange_id: String) {
        viewModel.getSymbolsBySymbolId(symbol_id: symbol_id, exchange_id: exchange_id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                guard let symbolModel = response.first else {
                    return
                }
                self.updateUI(data: symbolModel)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    @objc func searchCryptoSymbols(_ sender: UITapGestureRecognizer){
        let vc = ChooseCryptoViewController()
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func addDataChart(data: [HistoryLatestModel]) {
        for i in data {
            visitors.append(i.price_close ?? 0.0)
        }
        dismissActivityIndicator()
        updateChart()
    }
}

extension MainViewController: ChooseCryptoDelegate {
    func didSelect(symbolsModel: SymbolModel) {
        socket.disconnect()
        symbol_id = symbolsModel.symbol_id ?? "BINANCE_SPOT_BTC_USDT"
        updateUI(data: symbolsModel)
        visitors.removeAll()
        getHistoryLatestData(symbol_id: symbol_id)
        socket.connect()
    }
}

extension MainViewController: WebSocketDelegate {
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
            isConnected = true
            print("websocket is connected: \(headers)")
                do {
                    let data = try JSONSerialization.data(withJSONObject: [ "type": "hello",
                                                                            "apikey": Constants.apiKey,
                                                                            "heartbeat": true,
                                                                            "subscribe_data_type": ["ohlcv"],
                                                                            "subscribe_filter_period_id": ["1MIN"],
                                                                            "subscribe_filter_symbol_id": [symbol_id]
                    ], options: [])
                    socket.write(data: data)
                } catch {
                    print("[WEBSOCKET] Error serializing JSON:\n\(error)")
                }
        case .disconnected(let reason, let code):
            isConnected = false
            print("websocket is disconnected: \(reason) with code: \(code)")
            isConnected = true
        case .text(let string):
            let text = string.convertToDictionary()
            let t = text?["price_close"] as? Double
            priceLabel.text = t?.description
        case .binary(let data):
            print("Received data: \(data.count)")
        case .ping(_):
            break
        case .pong(_):
            break
        case .viabilityChanged(_):
            break
        case .reconnectSuggested(_):
            break
        case .cancelled:
            isConnected = false
        case .error(let error):
            isConnected = false
            handleError(error)
        }
    }
    
    @objc func fireTimer() {
        timer?.invalidate()
        socket.connect()
    }
    
    func handleError(_ error: Error?) {
        if let e = error as? WSError {
            print("websocket encountered an error: \(e.message)")
        } else if let e = error {
            print("websocket encountered an error: \(e.localizedDescription)")
        } else {
            print("websocket encountered an error")
        }
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}

extension MainViewController {
    private func updateChart() {
        var chartEntry = [ChartDataEntry]()
        
        for i in 0..<visitors.count {
            let value = ChartDataEntry(x: Double(i), y: visitors[i])
            chartEntry.append(value)
        }
        
        let line = LineChartDataSet(entries: chartEntry)
        line.mode = .cubicBezier
        line.lineWidth = 3
        line.setColor(.white)
        line.fill = Fill(color: .white)
        line.fillAlpha = 0.8
        line.drawFilledEnabled = true
        line.drawCirclesEnabled = false
        line.drawValuesEnabled = false
        
        
        let data = LineChartData()
        data.addDataSet(line)
        
        chartView.backgroundColor = .systemBlue
        chartView.data = data
        chartView.noDataText = "Идет загрузка"
        chartView.animate(xAxisDuration: 2.5)
    }
    
    func updateUI(data: SymbolModel) {
        symbolViewLabel.text = "\(data.asset_id_base ?? "")/\(data.asset_id_quote ?? "")"
        symbolLabel.text = "\(data.asset_id_base ?? "")/\(data.asset_id_quote ?? "")"
        priceLabel.text = data.price?.description ?? ""
        timeLabel.text = data.data_end ?? ""
    }
}
