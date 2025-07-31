# Art Splashy App🎨

Die Art Splashy App ist eine innovative Plattform, entworfen, um Künstler zu vernetzen, ihre Werke zu teilen und eine lebendige Gemeinschaft zu formen. Diese README bietet eine umfassende Einführung in die App, einschließlich ihrer Features, des technologischen Stacks, sowie Entwicklungs- und Nutzungshinweise.

## Inhaltsverzeichnis

- [Überblick](#überblick)
- [Funktionen](#funktionen)
- [Technologie-Stack](#technologie-stack)
- [Beispielverwendung](#beispielverwendung)
- [Entwicklertipps](#entwicklertipps)
- [Lizenz](#lizenz)
- [Kontakt](#kontakt)
- [Download/App Store-Link](#downloadapp-store-link)
- [Entwicklungsfahrplan](#entwicklungsfahrplan)
- [FAQs](#faqs)

## Überblick

Art Splashy ist darauf ausgerichtet, Künstler verschiedener Disziplinen zusammenzuführen. Es bietet eine Plattform, um Kunstwerke zu präsentieren, anderen Künstlern zu folgen und Teil einer kreativen Gemeinschaft zu sein. Nutzer können Profile erstellen, Beiträge veröffentlichen und mit anderen Künstlern in Verbindung treten.

## Funktionen🌟

- **Benutzerauthentifizierung:** Sicherer Zugang durch Firebase.
- **Profilverwaltung:** Erstellung und Pflege von Benutzerprofilen mit Bildern und Beschreibungen.
- **Beitragserstellung:** Möglichkeit für Künstler, ihre Werke mit Bildern und Beschreibungen zu teilen.
- **Kommentarfunktion:** Austausch durch Kommentare unter den Beiträgen.
- **Folgesystem:** Ermöglicht das Folgen und Entfolgen anderer Künstler.
- **Suchfunktion:** Integrierte Suche nach Beiträgen in der App.
- **Einfache Anmeldung:** Schneller Zugriff über Google oder Firebase Auth.

## Technologie-Stack🛠

- **Sprache:** Swift
- **Architektur:** MVVM (Model-View-ViewModel)
- **Asynchrone Programmierung:** Swift Async/Await
- **Datenbank:** Firebase Firestore, CoreData
- **Bildverarbeitung:** SwiftUI ,LazyVGrid, AsyncImage
- **Designwerkzeuge:** Figma, Canva
- **IDE:** Xcode
## Entwicklertipps

- Implementiere eine gründliche Fehlerbehandlung, besonders bei asynchronen Vorgängen.
- Führe umfassende Tests mit verschiedenen Szenarien durch, um die Funktionalität zu sichern.
- Achte auf die Konfiguration der Firebase Firestore-Regeln für sichere Datenoperationen.

## Lizenz

© [Art Splashy], 2024. Dieses Projekt ist ein persönliches Werk. Nutzung des Codes für inspirative Zwecke ist willkommen. Für eine vollständige oder teilweise Verwendung des Projekts zu anderen Zwecken, inklusive kommerzieller Nutzung, Modifikation oder Verteilung, bitte um Erlaubnis kontaktieren.

## Kontakt

- **Entwickler:** [Alexandros,Theodoropoulos]
- **E-Mail:** [artistsocialapp@gmail.com]
- **GitHub:** - [@AlexThe86](https://github.com/AlexThe86)

## Download/App Store-Link

(Ein App Store-Link wird hier hinzugefügt, sobald die App veröffentlicht ist.)

## Entwicklungsfahrplan

Zukünftige Updates und Erweiterungen der App sind geplant, einschließlich neuer Funktionen und Verbesserungen.

## FAQs

**Wie erstelle ich ein Künstlerprofil?**
Um ein Künstlerprofil zu erstellen, öffne die App und folge den Anweisungen zur Registrierung oder Anmeldung. Vervollständige dein Profil mit den erforderlichen Informationen.

**Wie teile ich meine Kunstwerke?**
Wähle die Option "Beitrag erstellen", lade deine Kunstwerke hoch und füge relevante Beschreibungen hinzu, um sie mit der Community zu teilen.

## API-Integration

Die Art Splashy App integriert eine externe API, um inspirierende Kunstzitate abzurufen. Diese API bietet Zitate in verschiedenen Kategorien, die genutzt werden können, um der App eine zusätzliche kreative Dimension zu verleihen.

### Integration der Inspirierenden Kunstzitate API

- **Voraussetzungen:** Um auf die API zugreifen zu können, benötigst du einen gültigen API-Schlüssel, der für die Authentifizierung bei der API-Anfrage erforderlich ist.

- **Einrichtung des API-Schlüssels:**
  - **API-Schlüssel erhalten:** Erstelle einen API-Schlüssel auf der Anbieterseite der Kunstzitate API.
  - **API-Schlüssel sicher speichern:** Bewahre den API-Schlüssel an einem sicheren Ort auf und vermeide es, den Schlüssel direkt im Quellcode zu speichern, insbesondere wenn der Code öffentlich zugänglich ist.

### Integration in die App

Die App verwendet Swift's `URLSession` für Netzwerkanfragen und `JSONDecoder` zum Parsen der JSON-Daten in Swift-Objekte. Dies ermöglicht eine effiziente und effektive Art, externe Daten in die App zu integrieren.

```swift
class QuotesAPI {
    static let shared = QuotesAPI()
    private let baseURL = URL(string: "https://api.api-ninjas.com/v1/quotes?category=art")
    private let apiKey = APIKeys.ArtQuoteAPIKey

       func getQuotes() async throws -> [ArtQuote] {
        guard let url = baseURL else {
            print("QuotesAPI: Invalid URL")
            throw HTTPError.invalidURL
        }

        print("QuotesAPI: Making request to \(url)")
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(apiKey, forHTTPHeaderField: "X-Api-Key")
        request.addValue("api.api-ninjas.com", forHTTPHeaderField: "X-RapidAPI-Host")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                print("QuotesAPI: Invalid response")
                throw HTTPError.invalidURL
            }

            print("QuotesAPI: Received HTTP status code: \(httpResponse.statusCode)")
            if httpResponse.statusCode != 200 {
                throw HTTPError.invalidURL
            }

            guard !data.isEmpty else {
                print("QuotesAPI: No data received")
                throw HTTPError.missingData
            }

            print("QuotesAPI: Successfully received data")
            return try JSONDecoder().decode([ArtQuote].self, from: data)
        } catch {
            print("QuotesAPI: Error during request - \(error)")
            throw error
        }
    }
}

## Beispielverwendung

```swift
// Swift-Beispielcode zur Überprüfung der "Folgen"-Beziehung zwischen zwei Benutzern
@ObservedObject var followViewModel = FollowViewModel()
let isFollowing = followViewModel.isFollowing(userId: "user1", followId: "user2")
