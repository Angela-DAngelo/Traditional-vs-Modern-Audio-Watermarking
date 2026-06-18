import os
import numpy as np
import soundfile as sf


# ============================================================
# SIMULAZIONE CANALE AUDIO MULTIPATH
# ============================================================

def channel_audio_multipath(
    input_signal,
    fs,
    dflight,
    distances,
    gamp,
    alphas
):
    """
    Simulazione canale acustico multipath.
    """

    c = 343.4  # velocità del suono [m/s]

    # ritardi in campioni
    delays = np.round(fs * np.array(distances) / c).astype(int)

    # tempo di volo del primo cammino
    tflight = dflight / c

    # ritardi complessivi
    tdelays = tflight + np.array(distances) / c

    # attenuazione dovuta alla distanza
    gamp_eff = np.array(gamp) / tdelays

    # normalizzazione
    gamp_eff = gamp_eff / np.max(gamp_eff)

    ns = len(input_signal)

    output_signal = np.zeros(ns)

    # generazione dei cammini multipli
    for d in range(len(delays)):

        delay = delays[d]

        delayed_signal = np.zeros(ns)

        delayed_signal[delay:] = input_signal[:ns - delay]

        output_signal += (
            (1 - alphas[d]) *
            gamp_eff[d] *
            delayed_signal
        )

    # normalizzazione finale
    output_signal = output_signal / np.max(np.abs(output_signal))

    return output_signal


# ============================================================
# DEFINIZIONE PROFILI
#
# Ordine di difficoltà crescente:
#
# P1 -> MODEL 5 (facile)
# P2 -> MODEL 4
# P3 -> MODEL 1
# P4 -> MODEL 2
# P5 -> MODEL 3 (difficile)
# ============================================================

c = 343.4

PROFILES = {

    # ========================================================
    # P1 -> MODEL 5 (caso ideale)
    # ========================================================
    "P1": {
        "dflight": 18e-3 * c,
        "distances": [0],
        "alphas": [0],
        "gamp": [1]
    },

    # ========================================================
    # P2 -> MODEL 4
    # ========================================================
    "P2": {
        "dflight": 3e-3 * c,
        "distances": [0, 2, 4, 6, 8],
        "alphas": [0, 0.25, 0.25, 0.25, 0.25],
        "gamp": [1, 0.8, 0.8, 0.8, 0.8]
    },

    # ========================================================
    # P3 -> MODEL 1
    # ========================================================
    "P3": {
        "dflight": 6e-3 * c,
        "distances": [0, 1, 2, 3, 4],
        "alphas": [0, 0.25, 0.25, 0.25, 0.25],
        "gamp": [1, 0.8, 0.8, 0.8, 0.8]
    },

    # ========================================================
    # P4 -> MODEL 2
    # ========================================================
    "P4": {
        "dflight": 12e-3 * c,
        "distances": [0, 2, 4, 6, 8],
        "alphas": [0, 0.25, 0.25, 0.25, 0.25],
        "gamp": [1, 0.8, 0.8, 0.8, 0.8]
    },

    # ========================================================
    # P5 -> MODEL 3 (caso difficile)
    # ========================================================
    "P5": {
        "dflight": 18e-3 * c,
        "distances": [0, 4, 8, 12, 16],
        "alphas": [0, 0.25, 0.25, 0.25, 0.25],
        "gamp": [1, 0.8, 0.8, 0.8, 0.8]
    }
}


# ============================================================
# INPUT AUDIO
# ============================================================

input_audio_path = "input.wav"

audio, fs = sf.read(input_audio_path)

# conversione mono se stereo
if len(audio.shape) > 1:
    audio = np.mean(audio, axis=1)

# nome base file
base_name = os.path.splitext(os.path.basename(input_audio_path))[0]

# ============================================================
# CARTELLA OUTPUT
# ============================================================

output_dir = "multipath_outputs"

os.makedirs(output_dir, exist_ok=True)

# ============================================================
# GENERAZIONE DELLE VERSIONI
# ============================================================

for profile_name, params in PROFILES.items():

    print(f"Processing {profile_name}...")

    degraded_audio = channel_audio_multipath(
        input_signal=audio,
        fs=fs,
        dflight=params["dflight"],
        distances=np.array(params["distances"]) * 1e-3 * c,
        gamp=params["gamp"],
        alphas=params["alphas"]
    )

    output_filename = f"{base_name}_{profile_name}.wav"

    output_path = os.path.join(output_dir, output_filename)

    sf.write(output_path, degraded_audio, fs)

    print(f"Saved: {output_path}")

print("\nDone.")
