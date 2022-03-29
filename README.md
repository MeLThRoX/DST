# DST - Decentralized Shop Toolkit
Sie wollten schon immer einen eigenen Shop betreiben doch haben keine Ahnung wie das geht? Dann sind Sie hier genau richtig. Das DST bietet die Möglichkeit einen voll funktionsfähigen Marketplace mit wenigen Klicks zu starten.


## How to use it
Tutorial, wie ein Nutzer den Shop selbst starten kann.
Was muss im Voraus von Seiten des Nutzers erfüllt sein.


## Programm-Overview
Zeichnung mittels Visio oder ähnlichem einfügen

## Verwendete Technologien

### Solidity

#### Verwendung

**Solidity** wird verwendet, um einen Smart-Contract zu Erstellen. Dieser Contract bietet die Grundlage für jeden Shop, der von einem User erstellt wird. Er bietet die Funktionalität zum Verwalten des Shop-Inventars und der Bestellabwicklung. Die einzelnen Funktionen des Contracts werden über das Svelte-Frontend angesteuert.

Der [Contract](backend/solidity) wird beim initialisieren des Shops automatisch vom Repo aus kompiliert und neu deployed. Dabei wird die Walletadresse des Admins innerhalb der verwendeten Chain hinterlegt. Diese wird für verschiedene Aufgaben benötigt. Auf der einen Seite wird das Aufrufen mancher Funktionen auf den Adminnutzer begrenzt. Der private Wallet-Key des Admins muss zuvor innerhalb einer .env Datei hinterlegt werden.

Beim Deployen des Contracts wird die Wallet-Adresse des Admins innerhalb des Contracts hinterlegt. Anhand dieser wird der Zugriif auf manche Funktionen, wie beispielsweise das Hinterlegen neuer Produkte oder dem Anpassen des Inventars, beschränkt. 

#### Warum Solidity?

Solidity ist **die** Programmiersprache um Smart-Contracts für die Ethereum-Chain und dessen Forks oder Testnets zu erstellen. Da der DST dezentralisiert laufen soll und Kaufprozesse von Produkten ohne die Verwendung einer zentralen Entität abschließen soll, ist die Ethereum-Chain mit Solidity die perfekte grundlage die nötige Logik zu entwickeln.

### Svelte 
**Svelte**:

**IPFS**:

**Ethers**:

### Docker

## Mögliche Hindernisse

### Gas-Fees
Wie bei vielen Projekten, die sich mit Ethereum befassen, ist eins der größten Probleme, die aktuell beim DST noch besteht, die hohen Gas-Fees für das Ausführen einer Transaktion. Das beeinflusst also nicht nur das Deployen des neuen Contracts im Rahmen der Initialisierung, das Hinzufügen von neuen Produkten, sondern auch den reinen Kaufprozess. Die Gas-Fees müssen immer von der Partei bezahlen, die eine Transaktion auslöst. Beim Kaufen eines Produktes muss der Kunde also die zusätzlichen Kosten tragen.

#### Mögliche Lösung
[**Arbitrum**](https://offchainlabs.com/) könnte eine Lösung für dieses Problem sein. Arbitrum verwendet Roll-Ups um dadurch die Gas-Fees und die Ausführungszeit von Transaktion zu reduzieren. Um diese Technologie auf DST zu übertragen, muss der Contract lediglich auf die Arbitrum-Chain deployed werden. Der Solidity-Code selbst muss dafür nicht angepasst werden.

### IPFS
Das Frontend eines DST-Shops wird unter anderem über IPFS erreichbar sein. In ersten Tests ist jedoch aufgefallen, dass IPFS teilweise sehr lange braucht, um die entsprechenden Komponenten zu laden und dann darzustellen. Das beeinflusst die Benutzerfreundlichkeit negativ. Bisher wurde noch keine konkrete Lösung zu dem Problem gefunden.

#### Erster Workaround
Um dem Admin eines DST-Shops die Möglichkeit zu geben, dass Problem zu umgehen, wird beim Initialisieren des Shops gleichzeitig eine Instanz auf IPFS und einem lokalen Port gestartet. Fall IPFS also zu langsam sein sollte, kann der Admin auf den lokal laufenden Server umsteigen. Dabei geht jedoch die Dezentralität des Shops teilweise verloren.
