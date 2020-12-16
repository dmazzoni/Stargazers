A sample SwiftUI application which lists the current stargazers of GitHub repositories.

### Requirements ###

- iOS 14.2+
- Xcode 12.2+

External dependencies are integrated via SwiftPM.

### GitHub rate limiting ###

The app defaults to unauthenticated API requests, which have a rate limit of 60 per hour. In case the rate limit is hit, the GitHub server returns HTTP 403 to all requests until the limit is reset.

To overcome this issue, tap the "Login" button and log in with your GitHub credentials. No credentials are stored or directly handled by the app, as the OAuth 2 authorization flow is carried out using Apple's AuthenticationServices framework.
