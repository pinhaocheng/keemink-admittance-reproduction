# Keemink Admittance Control — MATLAB Reproduction

![MATLAB](https://img.shields.io/badge/MATLAB-Required-blue.svg)
![Control System Toolbox](https://img.shields.io/badge/Toolbox-Control_System-orange.svg) 
![Status](https://img.shields.io/badge/Status-Work_In_Progress-yellow.svg)

This repository contains a MATLAB reproduction of the uncoupled admittance-frequency-response figures originally presented in:

> **[Admittance control for physical human–robot interaction](https://doi.org/10.1177/0278364918768950)**  
> *Arvid Q. L. Keemink (a.q.l.keemink@utwente.nl), Herman van der Kooij, and Arno H. A. Stienen*  
> The International Journal of Robotics Research, Vol 37, Issue 11

> _This code was made possible with the help of Codex (GPT-5.4 Extra High Reasoning) and Claude Code (Opus 4.6 High Effort)._

---

## 🎯 Scope

### ✅ Implemented Figure Recreations
- `fig06a`
- `fig07a` & `fig07b`
- `fig08`
- `fig09a`
- `fig10a`
- `fig11a`
- `fig12`
- `fig13a` *(partial implementation, some details still need to be ironed out)*
- `fig15a`

### 🚧 Pending Work
- **Coupled stability / ez-width panels** (`6b`, `9b`, `10b`, `11b`, `13b`, `15b`)

---

## ⚙️ Requirements

- **MATLAB**
- **Control System Toolbox**

---

## 📚 How to Cite

GitHub will surface citation metadata from [`CITATION.cff`](./CITATION.cff).

If you use this repository, cite both:

- this software repository
- the original Keemink et al. paper linked above

---

## 🚀 Quick Start

From the repository root, you can reproduce all figures or select specific ones.

**Generate all figures:**
```matlab
cd matlab
recreate_keemink_figures("all")
```

**Generate a specific figure:**
```matlab
cd matlab
recreate_keemink_figures("fig06a")
```

> **Note:** Generated files are automatically written to `outputs/figures/` at the repository root. This repo keeps the exported PNG figures on GitHub, while MATLAB `.fig` files stay ignored.

---

## 📁 Repository Layout

```text
.
├── README.md
└── matlab/
    ├── recreate_keemink_figures.m
    └── +keemink/
        ├── paperBaselineParams.m
        ├── naiveFeedbackOnlyCoeffs.m
        ├── baselineSystems.m
        ├── rigidClosedLoopAdmittance.m
        ├── bodeData.m
        ├── makeFigure6a.m
        ├── makeFigure7a.m
        ├── makeFigure7b.m
        ├── makeFigure8.m
        ├── makeFigure9a.m
        ├── makeFigure10a.m
        ├── makeFigure11a.m
        ├── makeFigure12.m
        ├── makeFigure13a.m
        └── makeFigure15a.m
```
