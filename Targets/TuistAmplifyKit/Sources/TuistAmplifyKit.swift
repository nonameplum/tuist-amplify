import Foundation
import Amplify
import AWSAPIPlugin
import AWSCognitoAuthPlugin

public final class TuistAmplifyKit {
    public static func hello() {
        print("Hello, from your Kit framework")

        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.add(plugin: AWSAPIPlugin())
            try Amplify.configure(AmplifyConfiguration(api: nil, auth: nil))

            try Amplify.API.add(interceptor: DummyInterceptor(), for: "")
        } catch {
            print(error)
        }
    }
}

struct DummyInterceptor: URLRequestInterceptor {
    func intercept(_ request: URLRequest) async throws -> URLRequest {
        return request
    }
}
