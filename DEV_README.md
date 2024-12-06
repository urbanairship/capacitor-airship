# Capacitor Airship Plugin Dev Readme

Failing `npm run verify`?

Try this from root directory:
`rm -rf node_modules package-lock.json ios/Pods ios/Podfile.lock`
`npm cache clean --force`
`npm install`
`cd ios && pod install`

