# E8257D — MATLAB Instrument Driver

A MATLAB class for controlling the **Agilent/Keysight E8257D PSG Analog Signal Generator** over a TCP/IP VISA connection. Provides a simple, object-oriented interface for configuring RF output power, frequency, modulation, and instrument state.

---

## Requirements

- MATLAB with the **Instrument Control Toolbox** (R2021a+ recommended for `visadev`)
- The E8257D must be accessible on the **local network** with a known IP address

---

## Installation

1. Clone or download this repository.
2. Add the folder to your MATLAB path:
   ```matlab
   addpath('/path/to/E8257D');
   ```

---

## Quick Start

```matlab
% Connect to the instrument by IP address
psg = E8257D('192.168.1.100');

% Set CW frequency to 1 GHz
psg.setCWFrequency(1e9);

% Set output power to -10 dBm
psg.setRFPower(-10);

% Enable RF output
psg.setOutput(true);

% Disable and clean up when done
psg.setOutput(false);
psg.deInit();
```

---

## API Reference

### Constructor

```matlab
obj = E8257D(ip_addr)
```

Connects to the instrument at the given IP address via TCPIP/VISA, clears the error queue, and disables modulation on startup.

| Parameter | Type | Description |
|---|---|---|
| `ip_addr` | `string` | IP address of the instrument (e.g. `'192.168.1.100'`) |

---

### RF Configuration

```matlab
psg.setCWFrequency(freq)
```
Sets the CW output frequency in Hz.

```matlab
psg.setRFPower(powdBm)
```
Sets the output power level in dBm.

```matlab
psg.setOutput(bool)
```
Enables (`true`) or disables (`false`) the RF output.

```matlab
psg.setModulation(bool)
```
Enables (`true`) or disables (`false`) the modulation output. Modulation is **disabled by default** on instantiation and on `deInit()`.

---

### Instrument Control

```matlab
psg.reset()
```
Sends `SYST:PRES` to restore the instrument to its preset state.

```matlab
psg.waitUntilDone()
```
Polls `*OPC?` until the instrument reports all pending operations are complete. Times out after 10,000 iterations with a warning.

```matlab
rsp = psg.sendResp(cmd)
```
Sends a SCPI query and returns the response string.

```matlab
psg.sendCommand(cmd)
```
Sends an arbitrary SCPI command with no return value.

```matlab
psg.deInit()
```
Resets the instrument, disables modulation, and releases the VISA connection. Returns `1` on success, `0` if the connection was already invalid.

---

## Notes

- Uses MATLAB's `visadev` interface (introduced in R2021a). If you are using an older version of MATLAB, you will need to adapt the constructor to use the legacy `visa()` function instead.
- The error queue is checked during construction via `SYST:ERR?` but the response is not currently validated — extend this if stricter error handling is needed.
- `deInit()` should always be called when finished to cleanly release the instrument.

---

## License

MIT License — see [LICENSE](LICENSE) for details.
