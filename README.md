# ECC-HLFB-eVOTING#
ECC-HLFB-eVOTING: An ECC-Hardware-Based and FAIR-Complaint e-Voting Scheme on Hyperledger Fabric with Zero-Knowledge Framework
# ECC-HLFB-eVOTING: AVISPA and FAIR Hardware Validation Code

This repository contains formal-verification and hardware-validation artifacts for the **ECC-HLFB-eVOTING** scheme: an ECC-assisted, Hyperledger-Fabric-based, FAIR-compliant e-voting workflow.

## Repository Structure

```text
ECC-HLFB-eVOTING/
├── avispa/
│   └── ecc_hlfb_evoting.hlpsl
├── hardware/
│   ├── rtl/
│   │   └── fair_validation_gate.v
│   └── tb/
│       └── tb_fair_validation_gate.v
├── scripts/
│   └── run_iverilog.sh
└── README.md
```

## 1. AVISPA Formal Verification

The AVISPA model is written in HLPSL and models the major participants:

- Candidate `C`
- Voter `V`
- Endorser `E`
- Orderer `O`
- Committer `F`

The model checks:

- secrecy of candidate identity,
- secrecy of voter pseudonym,
- secrecy of vote choice,
- authentication of candidate registration,
- authentication of voter registration,
- authentication of vote casting.

### Run AVISPA

```bash
cd avispa
avispa ecc_hlfb_evoting.hlpsl --ofmc
avispa ecc_hlfb_evoting.hlpsl --atse
```

Expected result:

```text
SUMMARY
  SAFE
```

## 2. FAIR Hardware Validation Gate

The Verilog module implements the validation condition:

```text
decision = CERT_OK ∧ SIG_OK ∧ TIME_OK ∧ NONCE_OK ∧ FMT_OK ∧ EP_OK
```

The transaction is accepted only when all checks are satisfied. Otherwise, the circuit emits a `REJECT` reason code.

## Reason Code Mapping

| Code | Meaning |
|---:|---|
| 0 | ACCEPT |
| 1 | CERT_FAIL |
| 2 | SIG_FAIL |
| 3 | TIME_FAIL |
| 4 | REPLAY_FAIL |
| 5 | FMT_FAIL |
| 6 | EP_FAIL |

## 3. Run Hardware Simulation

Install Icarus Verilog:

```bash
sudo apt-get update
sudo apt-get install iverilog gtkwave
```

Run simulation:

```bash
./scripts/run_iverilog.sh
```

Expected output includes cases for `ACCEPT`, `CERT_FAIL`, `SIG_FAIL`, `TIME_FAIL`, `REPLAY_FAIL`, `FMT_FAIL`, and `EP_FAIL`.

A waveform file is generated:

```text
fair_validation_gate.vcd
```

Open it using:

```bash
gtkwave fair_validation_gate.vcd
```

## 4. GitHub Upload Commands

```bash
git init
git add .
git commit -m "Add AVISPA and FAIR hardware validation artifacts"
git branch -M main
git remote add origin https://github.com/<username>/ECC-HLFB-eVOTING.git
git push -u origin main
```

## 5. Notes

This repository is intended for academic validation. The AVISPA file is an abstract protocol-level model, while the Verilog module is a lightweight hardware datapath for validation-output generation. Practical deployment with Hyperledger Fabric requires integration with Fabric CA/MSP, chaincode, endorsement policies, and peer/orderer logs.

## Citation

If this repository is used, cite the ECC-HLFB-eVOTING manuscript and mention the AVISPA, Scyther, and FAIR hardware-validation components.
