import iDenfySDK
import Foundation

@objc(IdenfySdkPlugin) class IdenfySdkPlugin: CDVPlugin {
    
    @MainActor
    @objc(idenfyInitialize:)
    func idenfyInitialize(command: CDVInvokedUrlCommand) {
        let authToken = command.arguments[0] as? String ?? ""
        initializeIdenfySDK(command: command, authToken: authToken)
    }

    @MainActor
    private func initializeIdenfySDK(command: CDVInvokedUrlCommand, authToken: String) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        var response = ""

        let idenfySettingsV2 = IdenfyBuilderV2()
            .withAuthToken(authToken)
            .build()

        let idenfyController = IdenfyController.shared
        idenfyController.initializeIdenfySDKV2WithManual(idenfySettingsV2: idenfySettingsV2)
        
        let idenfyVC = idenfyController.instantiateNavigationController()

        viewController?.present(idenfyVC, animated: true, completion: nil)

        idenfyController.handleIdenfyCallbacksWithManualResults(idenfyIdentificationResult: { [weak self] idenfyIdentificationResult in
            guard let self = self else { return }

            Task { @MainActor in
                do {
                    switch idenfyIdentificationResult.autoIdentificationStatus {
                    case .APPROVED:
                        // Handle approved auto-identification
                        break
                    case .FAILED:
                        // Handle failed auto-identification
                        break
                    case .UNVERIFIED:
                        // Handle unverified auto-identification
                        break
                    @unknown default:
                        break
                    }

                    switch idenfyIdentificationResult.manualIdentificationStatus {
                    case .APPROVED:
                        // Handle approved manual identification
                        break
                    case .FAILED:
                        // Handle failed manual identification
                        break
                    case .WAITING:
                        // Handle waiting manual identification
                        break
                    case .INACTIVE:
                        // Handle inactive manual identification
                        break
                    @unknown default:
                        break
                    }

                    let jsonData = try encoder.encode(idenfyIdentificationResult)
                    if let jsonString = String(data: jsonData, encoding: .utf8) {
                        response = jsonString
                    }

                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: response)
                    self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
                    
                } catch {
                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Encoding error: \(error.localizedDescription)")
                    self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
                }
            }
        })
    }
}