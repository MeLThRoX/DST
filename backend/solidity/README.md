# DST-Contract 

## Datentypen

#### struct Product
Dieser Datentyp wird vor allem für das Speichern des Inventars innerhalb des Contracts verwendet. Es wird ein Array dieses Datentyps definiert, innerhalb dessen alle einzelnen Produkte, die im Shop angeboten werden sollen, gespeichert sind. 

Zusätzlich dazu gibt es ein Mapping mmit dem Namen *inventory*, welches die ID eines Produktes auf die noch zur Verfügung stehende Anzahl von Produkten mappt. Dadurch kann garantiert werden, dass nur die Anzahl von Produkten verkauft werden kann, die aktuell noch im Lager des Anbieters vorhanden ist.

#### struct inputProduct
Reduzierte Version des struct Product Datentyps. Dieser wird als Übergabeparameter beim Erstellen von neuen Produkten verwendet.

#### struct Order
Datentyp, der für das Erfassen von getätigten Bestellungen verwendet wird. Dieser erfasst die gekauften Produkte, den Gesamtpreis und die verschlüsselten Kontaktinformationen des Kunden. Ein Array dieses Datentyps enthält alle Bestellungen. Diesen Array kann sich der Admin des DST-Shops innerhalb eines seperaten Panels anzeigen lassen. Beim laden der Bestellungen werden die Kontaktinformationen wieder entschlüsselt.

## Funkionen

### Management-Functions

Diese Funktionen können nur vom Admin ausgeführt werden und haben mit der Verwaltung der Produkte und dem Inventar des Shops zutun. Hier kann die Anzahl der zur Verfügung stehenden Produkte angepasst, der Admin der Seite geändert, der Preis eines Produktes geändert und neue Produkte erstellt werden. Auch das Abheben des Kapitals des Shops und das Auslesen der Bestellungen wird hier implementiert

### Order-Related
Hier gibts es lediglich die Funktion *buyCart*. Diese wird vom Frontend aus dann aufgerufen wenn ein Kunde seinen Kauf abschließt. Diese Funtkion erwartet ein Array von Cart-Structs, einen String, der dann innerhalb der neu erstellten Order für diese Bestellung hinterlegt wird, und die verschlüsselten Kontaktinformationen. Die Funktion berechnet zuerst den Gesamtpreis des Carts und überprüft dann, ob der Contract den Preis von der Wallet des Kunden abbuchen darf. Danach wird das Inventar des Shops angepasst und die Token vom Kunden in den DST-Contract selbst überwiesen. Danach wird die Bestellung gespeichert, um sie dem Admin später zur Vefügung stellen kann. 

### Getter-Functions
Diese Funktionen dienen primär dem Frontend, um öffentliche Informationen über den Shop, wie die zur Verfügung stehende Produkte und vielem mehr, laden zu können. Der Zugriff auf diese Funktionen ist nicht über eine Zugangskontrolle beschränkt. Das heißt jeder kann auf die Informationen, wenn er die Adresse des Conracts kennt, zugreifen.
