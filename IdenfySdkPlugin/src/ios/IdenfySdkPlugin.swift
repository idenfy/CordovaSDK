import iDenfySDK
import MaterialComponents
@objc(IdenfySdkPlugin) class IdenfySdkPlugin: CDVPlugin {
    @objc(idenfyInitialize:)
    func idenfyInitialize(command: CDVInvokedUrlCommand) {
        let authToken = command.arguments[0] as? String ?? ""

        initializeIdenfySDK(command: command, authToken: authToken)
    }

    private func initializeIdenfySDK(command: CDVInvokedUrlCommand, authToken: String) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = []
        var response = ""

        let idenfySettingsV2 = IdenfyBuilderV2()
            .withAuthToken(authToken)
            .build()

        let idenfyController = IdenfyController.shared
        idenfyController.initializeIdenfySDKV2WithManual(idenfySettingsV2: idenfySettingsV2)
        let idenfyVC = idenfyController.instantiateNavigationController()

        viewController?.present(idenfyVC, animated: true, completion: nil)

        idenfyController.handleIdenfyCallbacksWithManualResults(idenfyIdentificationResult: { idenfyIdentificationResult
                in
            do {
                switch idenfyIdentificationResult.autoIdentificationStatus {
                case .APPROVED:
                    // The user completed an identification flow and the identification status, provided by an automated platform, is APPROVED.
                    break
                case .FAILED:
                    // The user completed an identification flow and the identification status, provided by an automated platform, is FAILED.
                    break
                case .UNVERIFIED:
                    // The user did not complete an identification flow and the identification status, provided by an automated platform, is UNVERIFIED.
                    break
                }

                switch idenfyIdentificationResult.manualIdentificationStatus {
                case .APPROVED:
                    // The user completed an identification flow and was verified manually while waiting for the manual verification results in the iDenfy SDK. The identification status, provided by a manual review, is APPROVED.
                    break
                case .FAILED:
                    // The user completed an identification flow and was verified manually while waiting for the manual verification results in the iDenfy SDK. The identification status, provided by a manual review, is FAILED.
                    break

                case .WAITING:
                    // The user completed an identification flow and started waiting for the manual verification results in the iDenfy SDK. Then he/she decided to stop waiting and pressed a "BACK TO ACCOUNT" button. The manual identification review is still ongoing.
                    break

                case .INACTIVE:
                    // The user was only verified by an automated platform, not by a manual reviewer. The identification performed by the user can still be verified by the manual review if your system uses the manual verification service.
                    break
                }

                let jsonData = try encoder.encode(idenfyIdentificationResult)

                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    response = jsonString
                }
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR,
                                                   messageAs: response)
                self.commandDelegate!.send(
                    pluginResult,
                    callbackId: command.callbackId
                )
            } catch {

            }
        })
    }
}
