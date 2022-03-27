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

Der [Contract](backend/solidity) wird beim initialisieren des Shops automatisch neu deployed. Dabei wird die Walletadresse des Admins innerhalb der verwendeten Chain hinterlegt. Diese wird für verschiedene Aufgaben benötigt. Auf der einen Seite wird das Aufrufen mancher Funktionen auf den Adminnutzer begrenzt.

Beim Deployen des Contracts wird die Wallet-Adresse des Admins innerhalb des Contracts hinterlegt. Anhand dieser wird der Zugriif auf manche Funktionen, wie beispielsweise das Hinterlegen neuer Produkte oder dem Anpassen des Inventars, beschränkt. 

#### Warum Solidity?

Solidity ist **die** Programmiersprache um Smart-Contracts für die Ethereum-Chain und dessen Forks oder Testnets zu erstellen. Da der DST dezentralisiert laufen soll und Produkte ohne die Verwendung einer zentralen Entität Kaufprozesse abschließen soll, ist die Ethereum-Chain mit Solidity die perfekte grundlage die nötige Logik zu entwickeln.

### Svelte 
**Svelte**:

**IPFS**:

**Ethers**:

### Docker

## Mögliche Hindernisse
