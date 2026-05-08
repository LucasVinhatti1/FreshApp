<div align="center">

# Freshly

### *Freshness and trust at your fingertips*

[![Swift](https://img.shields.io/badge/Swift-5.9-orange?style=flat-square&logo=swift)](https://swift.org)
[![iOS](https://img.shields.io/badge/iOS-17%2B-blue?style=flat-square&logo=apple)](https://developer.apple.com/ios/)
[![CoreML](https://img.shields.io/badge/CoreML-Powered-brightgreen?style=flat-square&logo=apple)](https://developer.apple.com/documentation/coreml)
[![SwiftUI](https://img.shields.io/badge/SwiftUI-✓-purple?style=flat-square)](https://developer.apple.com/xcode/swiftui/)
[![License](https://img.shields.io/badge/License-MIT-lightgrey?style=flat-square)](LICENSE)

**Freshly** é um app iOS que usa Inteligência Artificial para identificar se frutas e vegetais estão frescos ou estragados — em tempo real, direto pela câmera do seu iPhone.

</div>

---

## Funcionalidades

- **Captura via câmera** — Tire uma foto diretamente pelo app
- **Classificação por IA** — Modelo CoreML treinado para reconhecer frutas e vegetais
- **Resultado imediato** — Exibe se o alimento está **fresco** ou **estragado** em segundos
- **Interface fluida** — Animações suaves com SwiftUI, incluindo o icônico efeito *fall & squish* da gota d'água

---

## Telas

| Tela Inicial | Resultado |
|---|---|
| Gradiente verde → amarelo → vermelho com botão de câmera centralizado | Foto em tela cheia com o veredito exibido em destaque |

> A cor do resultado muda dinamicamente: **verde** para fresco, **vermelho** para estragado.

---

## Como funciona

```
Câmera  ──▶  UIImage  ──▶  ProduceClassifier  ──▶  VNCoreMLRequest
                                                          │
                                              FruitAndVegetableClassifier.mlmodel
                                                          │
                                              ClassPrediction { classId, confidence }
                                                          │
                                              "This apple is fresh"
```

O `ProduceClassifier` usa o framework **Vision** para executar o modelo CoreML de forma assíncrona, retornando a classe com maior confiança e um top-5 de candidatos.

---

## Estrutura do Projeto

```
FreshApp/
├── Components/
│   ├── ContentView.swift        # HomePageView — tela principal
│   ├── CamButton.swift          # Botão que abre a câmera nativa
│   ├── PhotoResultView.swift    # Tela de resultado com a foto
│   └── FallAndSquish.swift      # Animação da gota d'água
│
├── Screens/
│   ├── OpenCam.swift            # CameraPicker (UIViewControllerRepresentable)
│   └── InfoAlert.swift          # Alerta de informações do app
│
├── Model/
│   └── ProduceClassifier.swift  # Wrapper do modelo CoreML com Vision
│
├── Models/
│   └── ClassifierVF.swift       # Modelo SwiftData para persistência
│
└── FruitAndVegetableClassifier.mlmodel  # Modelo de IA treinado
```

---

## Como rodar

### Pré-requisitos

- Xcode 15+
- iOS 17+ (dispositivo físico recomendado para usar a câmera)
- Swift 5.9+

### Passos

```bash
# 1. Clone o repositório
git clone https://github.com/seu-usuario/FreshApp.git

# 2. Abra no Xcode
open Freshly.xcodeproj

# 3. Selecione um dispositivo físico (câmera não funciona no simulador)

# 4. Build & Run
⌘ + R
```

> ⚠️ O uso da câmera requer um **iPhone físico**. O simulador do Xcode não suporta câmera ao vivo.

---

## Modelo de Machine Learning

O app utiliza o **`FruitAndVegetableClassifier.mlmodel`**, um modelo CoreML de classificação de imagens que:

- Identifica o **tipo** do alimento (ex: `apple`, `strawberry`, `banana`...)
- Classifica o **estado** como `fresh` ou `rotten`
- Retorna a predição com **score de confiança**

O output segue o padrão `{fruit}{freshness}` (ex: `appleFresh`, `strawberryRotten`), que é parseado automaticamente para uma frase amigável.

> ℹ️ O modelo **não cobre todos os tipos** de frutas e vegetais. Consulte o alerta de informações dentro do app para mais detalhes.

---

## Tecnologias

| Tecnologia | Uso |
|---|---|
| **SwiftUI** | Interface declarativa e animações |
| **CoreML** | Execução do modelo de IA on-device |
| **Vision** | Pré-processamento e inferência de imagem |
| **SwiftData** | Persistência de dados local |
| **UIKit** | Integração com a câmera (`UIImagePickerController`) |
| **Async/Await** | Classificação assíncrona sem travar a UI |

---

## Autor

Desenvolvido de forma totalmente autoral durante um curso de desenvolvimento IOS.

---

<div align="center">

*"Freshness and trust at your fingertips"*

</div>
