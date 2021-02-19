//
//  Communicator.swift
//  trading-app
//
//  Created by Hegedűs Csaba on 2021. 02. 18..
//

import Foundation
import Starscream
import RxStarscream
import RxSwift


class Communicator: NSObject {
    
    static let shared = Communicator()
    

    private let token = "c0n738f48v6v9lphnrjg"
    private let socketURL = URL(string: "wss://ws.finnhub.io?token=c0n738f48v6v9lphnrjg")
    private lazy var socket = WebSocket(url: socketURL!)
    private lazy var session = URLSession.shared
    
    private let disposeBag = DisposeBag()
    private let writeSubject = PublishSubject<String>()
    
    func establishConnection() {
        socket.rx.response.subscribe(onNext: { [unowned self] (response: WebSocketEvent) in
            self.handleStatus(status: response)
                
        }).disposed(by: disposeBag)
        
        socket.connect()

    }
    
    private func handleStatus(status: WebSocketEvent) {
        switch status {
        case .connected:
            print("Connected to the socket")
            print("sending requests...")
            sendingRequests()
            break
        case .disconnected(let error):
            print( "Disconnected with error: \(String(describing: error)) \n")
            showError(error: error)
            break
        case .message(_):
            //print( "RESPONSE (Message): \(msg) \n")
            break
        case .data(_):
            //print(  "RESPONSE (Data): \(data) \n")
            break
        case .pong:
            //print( "RESPONSE (Pong)")
            break
        }
    }
    
    private func sendingRequests() {
        Constants.Symbols.forEach { symbol in
            self.socket.write(string: symbol.toRequestQuery())
        }
    }
    
    var newData: Observable<[Int: ResponseData]> {
        return socket.rx.text.map { message -> [Int: ResponseData] in
            print(message)
            let data = message.data(using: .utf8)!
            return data.toSelectedMap()
        }.asObservable()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
    
    func fetchData(for symbol: String, completed: @escaping (_ company: CompanyResponse?) -> ()) {
        session.dataTask(with: URLRequest(url: symbol.toCustomURL())) { (data, response, error) in
            if let err = error {
                self.showError(error: err)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Status code : \(httpResponse.statusCode)")
            }
            
            guard let data = data else { return }
            do {
                let json = try JSONDecoder().decode(CompanyResponse.self, from: data)
                print(json)
                
                DispatchQueue.main.async {
                    completed(json)
                }
            }
            catch {}
            
        }.resume()
    }
}

extension Communicator {
    private func showError(error: Error?) {
        UIAlertController.showAlertViewWithTitle("Error", message: "Disconnected with error: \(error?.localizedDescription ?? "")", buttonTitle: "try again", buttonAction: {
            self.socket.connect()
        }, parentController: AppDelegate.shared.rootController)
    }
}

extension Data {
    func toSelectedMap() -> [Int: ResponseData] {
        var dictionary = [Int: ResponseData]()
        do {
            let responseData = try JSONDecoder().decode(FinnResponse.self, from: self)
            print(responseData)
            for (index, symbol) in Constants.Symbols.enumerated() {
                if let item = responseData.data.last(where: { $0.id == symbol }) {
                    dictionary[index] = item
                }
            }
        } catch {
            print("JSON decode error.")
        }
        return dictionary
    }
}

extension String {
    func toRequestQuery() -> String {
       return "{\"type\":\"subscribe\",\"symbol\":\"\(self)\"}"
    }
    
    func toCustomURL() -> URL {
        return URL(string: "https://finnhub.io/api/v1/stock/profile2?symbol=\(self)&token=c0n738f48v6v9lphnrjg")!
    }
}

struct CompanyResponse: Decodable {
    let name: String
    let country: String
    let logo: String
    let ticker: String
}
