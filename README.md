# 🎵 Model-Driven and Learning-Based Audio Watermarking: An Experimental Comparison

![Python](https://img.shields.io/badge/Language-Python-3776AB?logo=python&logoColor=white&style=for-the-badge)
![MATLAB](https://img.shields.io/badge/Language-MATLAB-0076A8?logo=mathworks&logoColor=white&style=for-the-badge)


### Traditional Model-Driven vs AI-Based Audio Watermarking

This repository accompanies the research work *"Model-Driven and Learning-Based Audio Watermarking: An Experimental Comparison"*.

This project provides a systematic comparison between **traditional signal-processing** and **AI-based** audio watermarking methods.  
We implemented the classical **STAMP** system and benchmarked it against three state-of-the-art neural approaches - **AudioSeal**, **WavMark**, and **SilentCipher** - across diverse datasets (speech, multilingual speech, and music) and a wide range of perturbations.

---

## 💡 Overview

Digital audio watermarking is a core technology for copyright protection, authenticity verification, and synthetic media detection.  
While recent AI-based models have been proposed for watermark embedding and detection, their actual robustness compared to traditional designs remains uncertain.

This project evaluates both paradigms under identical conditions, assessing:
- **Imperceptibility**
- **Robustness**
- **Bit recovery accuracy**

The repository includes implementations, benchmarks, and evaluation tools used in the comparative study.  
It aims to provide a **reproducible experimental framework** for researchers and practitioners interested in testing or extending audio watermarking methods under standardized conditions.

Overall, the results highlight that **classical signal-processing systems** still achieve competitive and often superior robustness compared to modern neural architectures, emphasizing the enduring value of traditional design principles in contemporary audio watermarking.


---

## 🤖 Audio Watermarking Systems

- **STAMP**: **S**pectral **T**ransform-domain **A**udio **M**arking with **P**erceptual model (proposed classical system)
- **AudioSeal**: https://github.com/facebookresearch/audioseal (state-of-the-art AI-based system)
- **WavMark**: https://github.com/wavmark/wavmark (state-of-the-art AI-based system)
- **SilentCipher**: https://github.com/sony/silentcipher (state-of-the-art AI-based system)

---

## ⚙️ Evaluation Framework

- **Datasets:** AudioMarkBench, LibriSpeech, FMA, PhonemeDF 
- **Attacks:** Time Stretch, Gaussian Noise, Background Noise, Opus, EnCodec, Quantization, Highpass filter, Lowpass filter, Smooth, Echo, Mp3 compression 
- **Metrics:**  
  - Bit Recovery Accuracy (ACC)  
  - False Positive / Negative Rates (FPR, FNR)  
  - Audio Quality: SNR, PESQ, STOI, ViSQOL  

---

## 🗂️ Repository Structure

The repository is organized into four main directories:

- **Attacks/**: signal perturbation scripts for robustness testing. 
- **Dataset/**: audio datasets used for benchmarking and evaluation (speech and music).  
- **Systems/**: implementations of both classical and AI-based watermarking systems.   
- **QualityMetrics/**: evaluation tools and scripts for measuring audio quality and imperceptibility (e.g., SNR, PESQ, STOI, ViSQOL).
- **Results/**: sample outputs 

```text
AudioWatermarking_AI_vs_Traditional/
│
├── Attacks/
│   ├── apply_audio_perturbations.py
│
├── Dataset/
│   ├── AudioMark/               # Multilingual speech benchmark
│   ├── LibriSpeech/             # English speech dataset
│   └── FMA/                     # Free Music Archive dataset
│   └── PhonemeDF/               # Sintetic speech dataset
│
├── Systems/
│   ├── STAMP/                   # Classical signal-processing system 
│   ├── AudioSeal/               # AI-based sequence-to-sequence watermarking
│   ├── WavMark/                 # Spectrogram-based neural watermarking
│   └── SilentCipher/            # Deep spectrogram watermarking with psychoacoustic model
│
├── QualityMetrics/
│   ├── quality_metrics.py
│
├── Results/                     # Evaluation outputs 
│   ├── Audio/                   # Sample watermarked audio
|
└── README.md

```

---

## 📘 Reference

If you use or reference this work, please cite:

XXXXXXXXXXXXXX


---

## 📩 Contacts
Angela D’Angelo — Universitas Mercatorum, Rome, Italy  
📧 angela.dangelo@unimercatorum.it  



