#  Demo realm decryption bug

Realm issue : https://github.com/realm/realm-cocoa/issues/7013

## Reproduce the bug through the app
1. Launch DemoRealmBug app on your mac an and use "Initialize a new realm db"
2. Transfere the realm file to an ios device
3. Copy the encryption key
4. Launch DemoRealmBug app on your ios device
5. Use "Import a realm db" to import your realm file and insert your key
6. The app crashes and the error appears in the logs

## Informations
- You can try to import the same realm db with the same key in the mac app and it will works well
- You can initialize the realm db on ios and import it on mac os and it will works well
