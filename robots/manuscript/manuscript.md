# Deploy, Augment, or Hire? A Total-Cost-of-Ownership and Cohort Framework for Robot-Labor Deployment Decisions Across Global Wage Regions

Manuscript type: Research Article

Prepared for submission to Science Robotics

Author and affiliation: Shivashish Borah¹ (ORCID 0009-0000-9726-2864). ¹AI Humane Tech Pvt Ltd, Bengaluru, India. Corresponding author: shivashish@aihumane.in.

Date: 29 June 2026.  Body word count (excl. references and appendices): ~19,000.

Scope and ethical framing. This paper analyses the economics of capital-vs-labor deployment decisions. Lifecycle, depreciation, refurbishment, and retirement concepts apply exclusively to robots and capital equipment. Human labor is modeled solely through standard labor economics (wages, statutory benefits, training, overhead). “Human-capital depreciation,” where it appears, denotes the decay of skills, knowledge, and earning capacity (the foundational human-capital economists Gary Becker and Jacob Mincer) — a property of skills, never of persons. Nothing herein treats people as depreciable assets, assigns them salvage value, or supports displacing, retiring, or scrapping workers judged “unproductive.” Cost ratios describe equipment and labor-market prices, not human worth.

## Abstract

Deployed robotics has shifted from a capital-acquisition question to a deployment-economics question: the dominant lifetime cost of a fielded robot is not its bill of materials (BOM) but the recurring cost of integration, service, and end-of-life decisions, all of which interact with the local price of human labor and with the supply chain that prices the robot itself. Most published comparisons either report a single-site payback figure or compare a sticker price to an hourly wage, ignoring both full robot total cost of ownership (TCO) and properly loaded labor cost. We develop a transparent, fully parameterized cost model that expresses robot TCO as the sum of manufactured cost (BOM plus manufacturing overhead), deployment and integration, lifetime service and maintenance (modeled as a multiple of manufactured cost, 1x-2x), operating cost, and a refurbish-or-retire decision rule applied to the capital asset. In parallel we model loaded human labor cost using standard labor economics, and we treat the two depreciation concepts on the two sides of the comparison — physical robot depreciation (~5%/yr) and human-capital (skills) depreciation (~7%/yr) — as conceptually distinct, the latter strictly in the Becker-Mincer sense of skill decay rather than any retirement of people.

We instantiate the model with publicly reported data for seven regions (India, the United States, Europe, other Asian economies, Africa, Australia, and small-island/small-economy nations), decompose the robot BOM by subsystem and representative vendor, and add a cohort analysis comparing AI/robotic systems against entry-, mid-, and expert-tier robotics-AI human cohorts on cost, productivity, ramp-up time, skill vs machine depreciation, and per-cohort break-even. Under central assumptions a representative service-class robot (BOM ~ Rs 9.5 lakh, where 1 lakh = 100,000 rupees, so ~950,000 rupees ~ US$11,400) reaches annualized parity with high-wage regions within roughly one to three years but may never reach parity in the lowest-wage regions over a five-year service life. We derive a break-even wage for each region, build a regional-cohort outcome matrix, and present a deployment decision framework. Sensitivity and two-way scenario analysis show utilization and the service multiplier dominate. Macro figures (an operational stock of ~4.66 million units reported by the International Federation of Robotics (IFR), against a world population of ~8.2 billion) show penetration on the order of one robot per ~1,760 people, concentrated in high-wage manufacturing. We conclude that automation favorability is strongly regional and cohort-specific, that AI/robotics most often augments rather than wholesale displaces skilled cohorts, and that economic models capture deployment cost only — they must never be read as judgments of human worth.

Keywords: deployed robotics; total cost of ownership; automation economics; loaded labor cost; human-capital depreciation; cohort analysis; payback period; bill of materials; break-even wage; robot penetration; regional wage comparison.

## 1. Introduction and motivation

### 1.1 From acquisition to deployment economics

The installed base of service and industrial robots has grown rapidly over the past decade, and the decisive cost question facing operators has changed character. A decade ago the binding question was largely one of capital acquisition: could an organization afford to buy the robot at all? Hardware was expensive, financing was scarce, and the sticker price dominated the decision. Today, with hardware costs falling, contract manufacturing maturing, and financing widely available, the binding question is one of deployment economics: over a realistic service life, and at a specific site with a specific wage structure, does a fielded robot cost less than the loaded cost of the human labor it would replace or, more often, augment?

This is a fundamentally different question, and it is poorly served by the figures most commonly cited in vendor materials and even in parts of the academic literature. The acquisition framing asks what the robot costs. The deployment framing asks what it costs to keep this robot productive here, for years, compared with the fully loaded cost of the people who would otherwise do the work. Answering the second question requires a model of robot total cost of ownership that goes well beyond the BOM, a model of loaded labor cost that goes well beyond the wage, and an explicit treatment of how each side changes over time — including the often-confused notion of depreciation.

The stakes of getting this right are practical and large. Capital budgeting committees, plant managers, and robotics vendors all rely on payback and return-on-investment figures to allocate scarce capital. When those figures are built on incomparable quantities — full machine lifetime cost on one side, a bare hourly wage on the other — the resulting decisions are systematically biased, and the bias is not uniform: it points one way in high-wage economies and the opposite way in low-wage economies. A framework that makes the comparison fair is therefore not a theoretical nicety but a precondition for rational deployment.

### 1.2 Three recurring gaps

We identify three gaps that this paper addresses. First, vendors and analysts frequently quote robot cost as a purchase price, when the well-documented reality is that hardware is a minority of lifetime cost; integration, service, downtime, and end-of-life dominate the total. A comparison built on sticker price systematically understates robot cost. Second, the same sources frequently quote the labor comparator as a bare wage, when the economically correct comparator is loaded labor cost, which adds statutory benefits, recruiting and training amortization, supervision, and facility overhead. Comparing a full robot TCO against a bare wage — or a robot sticker price against loaded labor — produces conclusions that can be wrong by a factor of two or more and that flip sign across wage regions.

Third, and most subtly, the word depreciation is used for two entirely different things on the two sides of the comparison. On the robot side it means physical wear and obsolescence of a capital asset, with a salvage value and a refurbish-or-retire decision. On the human side, the legitimate labor-economics concept of human-capital depreciation refers to the decay of the market value of skills and knowledge when they are not maintained — a property of skills, not of people. Conflating these two leads to category errors that are not only analytically wrong but ethically unacceptable. We keep them rigorously separate.

Beyond these three, a fourth, structural gap is the absence of cohort resolution. Labor is rarely homogeneous: a deployment competes not against an undifferentiated worker but against a specific tier of skill performing a specific mix of tasks. A framework that collapses entry, mid, and expert talent into a single wage cannot say where automation displaces, where it augments, and where it is simply uneconomical. Our cohort analysis (Section 7) closes this gap.

### 1.3 Contributions

This paper makes the following contributions. (i) A parameterized robot-TCO model that treats service cost as a multiple of manufactured cost and embeds a refurbish-or-retire rule for the capital asset, together with a subsystem-level BOM and supply-chain decomposition that explains both the level and the volatility of robot cost. (ii) A loaded-labor-cost model grounded in standard labor economics with refined India-anchored parameters and worked examples. (iii) An explicit, side-by-side treatment of robot depreciation (~5%/yr) and human-capital (skill) depreciation (~7%/yr), the latter strictly in the Becker-Mincer sense. (iv) A seven-region comparison with robot-to-labor ratios, implied payback, and a derived break-even wage per region. (v) A novel AI-vs-skilled-human cohort analysis across entry, mid, and expert robotics-AI cohorts and across regions, including a regional-cohort outcome matrix and worked break-even examples. (vi) A deployment decision framework synthesizing the model into an operational rule. (vii) An expanded one-at-a-time, two-way, and scenario sensitivity analysis. (viii) A macro penetration analysis relating global robot stock to world population and workforce; and appendices providing a complete notation glossary, equation summary, and data/assumptions register.

### 1.4 Structure of the paper

Section 2 reviews the literature on robot TCO, labor-cost accounting, human-capital theory, the automation-employment debate, prior frameworks, and measurement challenges. Section 3 presents the methodology and robot-TCO model, including the BOM decomposition and a worked numeric example. Section 4 develops the loaded-labor model, refined parameters, and a worked example. Section 5 distinguishes the two depreciation concepts. Section 6 presents the multi-region comparison, per-region assessments, and break-even wages. Section 7 presents the cohort analysis with a regional-cohort matrix. Section 8 presents the deployment decision framework. Section 9 reports sensitivity, two-way, and scenario analysis. Section 10 presents the macro penetration analysis. Section 11 discusses implications, policy, firm strategy, limitations, ethics, and future work; Section 12 concludes. Appendices A-D provide notation, equations, data sources, and methodology notes.

## 2. Literature review and background

### 2.1 Robot total cost of ownership

Practitioner and industry analyses converge on a consistent picture of robot cost structure. The robot hardware is typically only 25-40% of the cost of a functioning, reliably producing cell, with the remaining 60-75% coming from integration, tooling, safety systems, programming, operation, and maintenance (1). Summed across a typical 10-15 year industrial service life, reported TCO commonly lands at three to five times the initial purchase price; over a shorter seven-year horizon, roughly 1.8-2.5x capex (1, 2). Annual maintenance is reported at roughly 5-15% of purchase price per year depending on duty cycle and robot class, with downtime frequently the single largest operating contributor (2, 5).

These findings have two consequences for modeling. First, any credible comparison must use lifetime TCO, not purchase price. Second, because maintenance and service scale with the complexity and value of the manufactured system rather than being a fixed sum, it is more faithful to model service as a multiple of manufactured cost than as a flat annual figure. We adopt this convention (Section 3) and treat the multiplier as a modeled scenario variable spanning 1x to 2x of manufactured cost. This choice also has the virtue of making BOM volatility propagate correctly into service cost, a property a flat-fee model lacks.

### 2.2 Loaded labor cost accounting

In labor economics the relevant quantity is total compensation, not the wage. Official series — for example the OECD measure of labour compensation per hour worked and the U.S. Bureau of Labor Statistics Employer Costs for Employee Compensation — define compensation as gross wages and salaries plus employers' social contributions (3, 6). For a deployment comparison, the relevant figure is broader still: it adds the amortized cost of recruiting, onboarding, and training, plus the supervision and facility overhead required to keep a worker productive (4). We refer to this as loaded labor cost and emphasize that it is a labor-market price, carrying no implication about the value of the person performing the work.

International comparisons reveal an order-of-magnitude dispersion in loaded labor cost. Manufacturing compensation exceeds US$45/hour in the United States and is comparable in much of Western Europe and Australia, falls to single-digit dollars in major Asian manufacturing economies after social contributions, and is lower still across much of South Asia and Africa (3, 6, 7, 8, 9, 10). This dispersion, set against a robot cost that trades in international markets and is therefore roughly regionally invariant, is the central tension this paper formalizes. The dispersion is also the reason a single global payback figure is meaningless: the same machine has a sub-year payback in one economy and an infinite payback in another.

### 2.3 Human-capital theory and skill depreciation

The human-capital tradition originating with Becker and Mincer treats education and on-the-job experience as investments that raise an individual's productivity and earnings, and that, like any stock, can depreciate if not maintained (11). Crucially, human-capital depreciation refers to the decline in the market value of skills and knowledge — skill obsolescence — not to any notion of a person becoming a spent asset. Empirical estimates of the depreciation rate vary widely by method, country, and skill type, from under 1% to double-digit percentages per year, with technical and specific skills depreciating faster than general skills, and with returns to experience offsetting depreciation early in a career (11, 12).

We use this concept narrowly and explicitly: it enters our labor model only through the rate at which training investment must be refreshed, modestly affecting the annual training component of loaded labor cost. It never reduces a worker's value as if they were wearing out, and it never triggers any retirement rule. We return to this distinction in Section 5, because preserving it is essential to the paper's ethical integrity. The empirical literature also supports our choice of a higher rate (~7%) for narrow technical skills than for general skills, and motivates the cohort-specific rates used in Section 7.

### 2.4 Automation, employment, and the task-based view

A substantial literature examines automation's effect on employment and wages, increasingly through a task-based lens in which technologies substitute for some tasks while complementing others, shifting rather than simply eliminating labor demand. This view supports the augmentation framing that our cohort analysis makes quantitative (Section 7): the economically relevant question is rarely whether a robot can replace a whole worker, but which tasks within a role are economically automatable at the local wage, and what the residual human role becomes. We treat displacement, augmentation, and economic infeasibility as three distinct outcomes per cohort rather than as a binary. The task-based view also explains why aggregate robot penetration (Section 10) remains low even where individual tasks are heavily automated: most roles contain a mix of automatable and non-automatable tasks.

### 2.5 A real-world deployment datapoint (illustrative)

As an order-of-magnitude anchor for fielded deployment scale and the capital intensity of bringing robots to market, we note a user-provided datapoint: Ati Robotics is reported to have ~231 robots deployed worldwide and to have raised about US$41M through a Series B round. This figure is user-provided and illustrative only; it has not been independently verified and is used solely to motivate scale, not as a model input.

### 2.6 Comparison with prior TCO frameworks

Prior robot-TCO frameworks typically fall into three families: phase-based accounting (acquisition, integration, operation, maintenance, end-of-life), ratio-of-capex heuristics (TCO = k x purchase price), and detailed activity-based costing for a specific cell. Each has strengths and weaknesses. Phase-based accounting is transparent but rarely connects to the labor comparator. Ratio heuristics are convenient but hide the drivers and cannot be sensitized. Activity-based costing is precise but bespoke and non-portable. Our model is deliberately a hybrid: it preserves phase transparency (Eqs. 1-6), expresses the largest recurring phase as a capex-linked multiple so it can be sensitized (Eq. 3), and — uniquely — couples the result to a loaded-labor comparator and a cohort structure so that the output is a deployment decision, not merely a cost number.

### 2.7 Measurement and comparability challenges

- Definitional drift. National statistics differ on what counts as compensation (e.g., treatment of bonuses, in-kind benefits, payroll taxes), so cross-country figures require harmonization and remain approximate.
- Informality. In many low-wage economies a large share of labor is informal, with compensation far below formal-sector averages, widening within-region dispersion beyond what headline figures show.
- Robot heterogeneity. TCO multiples vary by robot class (fixed industrial arm, mobile robot, humanoid, service robot); a single multiple is an approximation across a heterogeneous fleet.
- Productivity equivalence. Comparing a robot to a worker presumes a task-equivalence that is itself an assumption; throughput, quality, and flexibility rarely map one-to-one. We address this with productivity normalization in Section 7.

## 3. Methodology and robot total-cost-of-ownership model

### 3.1 Modeling philosophy

Our modeling philosophy is transparency over precision. Every cost component is made explicit and parameterized so that a reviewer can substitute their own figures and re-derive every result. We deliberately separate three classes of input: facts (cited public data), assumptions (clearly flagged modeling choices), and illustrative or user-provided datapoints (flagged and excluded from load-bearing conclusions where unverified). All monetary conversions use Rs 83/US$ and are rounded. Appendix C provides a complete register of which inputs are facts, assumptions, or illustrative.

### 3.2 Core equations

We define robot TCO over a service life of N years. Manufactured cost combines the bill of materials and manufacturing overhead:

> **C_mfg = C_BOM + C_oh (1)**

Deployment and integration — commissioning, safety, programming, and fixturing — is incurred once at fielding:

> **C_deploy = C_integration + C_safety + C_programming + C_fixturing (2)**

Following the empirical ranges in Section 2.1, lifetime service and maintenance is modeled as a multiple s of manufactured cost, with s spanning a modeled scenario range of 1x to 2x:

> **C_service = s * C_mfg ,   s in [1, 2] (3)**

Lifetime TCO before end-of-life credit aggregates manufactured cost, deployment, service, and operating cost, net of the end-of-life credit V_eol for the capital asset (resale or refurbishment value):

> **TCO = C_mfg + C_deploy + C_service + C_energy + C_downtime - V_eol (4)**

The annualized robot cost — the quantity compared against loaded labor — divides lifetime TCO by service life and a utilization factor U (effective productive-shift fraction, 0 < U <= 1) that converts calendar life into productive capacity, correctly penalizing under-used assets:

> **A_robot = TCO / (N * U) (5)**

Operating cost itself decomposes into energy and downtime, the latter often dominant; we carry both explicitly so that reliability improvements can be valued:

> **C_op = C_energy + C_downtime = (P_kW * h * lambda * N) + (d * L_hourly * N) (6)**

where P_kW is mean power draw, h annual operating hours, lambda the electricity tariff, d annual downtime hours, and L_hourly the cost of idle dependent labor or lost output per downtime hour.

### 3.3 Refurbish-or-retire decision rule (capital equipment only)

At a maintenance event for an aging robot, the operator chooses between refurbishing the existing unit to a residual life N_r at cost C_refurb and retiring it for a replacement with full-life annualized cost A_new. The rule retains the asset when refurbishment is cheaper per productive year:

> **Refurbish if  C_refurb / (N_r * U) < A_new ;  otherwise retire and replace (7)**

This refurbish-or-retire rule applies only to robots and capital equipment. It is never applied to human labor. Workers are not assets with salvage value; the labor model in Section 4 contains no depreciation-of-person, retirement, or scrappage term of any kind.

### 3.4 Worked anchor figures

We instantiate the model with a representative service-class robot. User-provided / illustrative anchors are flagged; conversions use Rs 83/US$.

| Component | Value | Basis / flag |
| --- | --- | --- |
| BOM (C_BOM) | Rs 9.5 lakh ~ US$11,400 | User-provided anchor (illustrative) |
| Manufacturing overhead (C_oh) | ~35% of BOM ~ US$4,000 | Modeling assumption |
| Manufactured cost (C_mfg) | ~ US$15,400 | Eq. 1 |
| Deployment / integration | US$10,000-50,000 (mid ~ 25,000) | Cited range (1, 5) |
| Service multiplier (s) | 1x - 2x of C_mfg | Modeled scenario (2, 5) |
| Service cost (C_service) | US$15,400 - 30,800 | Eq. 3 |
| Service life (N) | 5 years (refined base case) | User-refined; sensitized 5-12 |
| Utilization (U) | 0.70 (central) | Assumption; sensitized 0.4-0.95 |

Table 1. Robot TCO anchor figures. The BOM is a user-provided illustrative anchor; overhead, life, and utilization are modeling assumptions; deployment and service ranges are from cited industry sources.

### 3.5 Robot BOM and supply-chain cost decomposition

The BOM is a minority of lifetime TCO, but its internal structure matters because it drives both the level and the volatility of robot cost, and — through the service multiplier — propagates into lifetime TCO with leverage. We decompose the BOM into major subsystems and name representative vendors as illustrative examples only; these are neither endorsements nor verified prices, and the percentage split is an illustrative cost structure, not a quoted bill of materials.

| Subsystem | Representative vendor(s) (illustrative) | Approx. % of BOM | Cost-driver notes |
| --- | --- | --- | --- |
| Compute / onboard AI | NVIDIA, Advantech | 18-25% | GPU (graphics processing unit) / SoC (system-on-chip) pricing; allocation-driven volatility |
| LiDAR | Ouster, Hesai | 12-20% | Solid-state transition lowering but still volatile |
| Depth / vision cameras | Intel RealSense | 5-9% | Commoditizing; supply gaps on discontinuation |
| Actuators / motors / gearboxes | (various; harmonic drives) | 22-30% | Precision reducers are a structural cost floor |
| Power, contactors, switchgear | Schneider Electric | 8-12% | Industrial-grade; relatively stable pricing |
| Battery / power electronics | (various) | 7-11% | Cell-price and BMS (battery management system) sensitive |
| Chassis, structure, wiring, misc. | (various) | 10-15% | Labor and metals exposure |

Table 2. Illustrative robot BOM decomposition. Vendors are representative examples, not endorsements; percentages are an illustrative cost structure, not a quoted BOM.

Three subsystems — compute, LiDAR, and actuation — together account for roughly half to two-thirds of the BOM and are the main sources of cost volatility. Compute pricing is exposed to GPU/SoC allocation cycles and can swing materially within a single product generation; LiDAR pricing is falling with the solid-state transition but remains supplier-concentrated; precision actuation (harmonic and cycloidal reducers) is a structural cost floor with few qualified suppliers worldwide. Power and switchgear from established industrial vendors is comparatively stable and is rarely the binding constraint.

Because service cost is modeled as a multiple of manufactured cost (Eq. 3), BOM volatility propagates into lifetime TCO with leverage: a spike in compute or sensor prices raises both C_mfg and, through s, C_service, so a 20% compute-price shock can move lifetime TCO by more than its direct BOM share alone. Supply-chain concentration also affects risk, not just level: single-source sensors and reducers introduce lead-time and obsolescence risk that manifests as downtime cost in Eq. 6. These observations argue that design-for-serviceability, second-sourcing, and modularity do more for deployment economics than nominal BOM reduction at purchase.

### 3.6 Worked end-to-end numeric example

To make the model concrete, Table 3 traces a single robot from BOM to annualized cost under the central assumptions. This is the computation underlying every R value in later sections.

| Step | Quantity | Value | Source / Eq. |
| --- | --- | --- | --- |
| BOM | C_BOM | $11,400 | Anchor (illustrative) |
| + overhead (35%) | C_oh | $4,000 | Assumption |
| = manufactured cost | C_mfg | $15,400 | Eq. 1 |
| Deployment | C_deploy | $25,000 | Eq. 2 (mid) |
| Service (s=1.5) | C_service | $23,100 | Eq. 3 |
| Operating (energy+downtime) | C_op | $6,000 | Eq. 6 |
| End-of-life credit | -V_eol | -$2,000 | Eq. 4 |
| = lifetime TCO | TCO | $67,500 | Eq. 4 |
| Annualized (N=5, U=0.7) | A_robot | $19,300 | Eq. 5 |
| Annualized (N=8, U=0.7) | A_robot | $12,100 | Eq. 5 (alt) |

Table 3. Worked end-to-end robot cost computation under central assumptions. The five-year life yields ~$19,300/productive year; an eight-year life yields ~$12,100.

## 4. Loaded human labor cost model and refined parameters

### 4.1 Core equations

We model loaded annual labor cost using standard labor economics, with no lifecycle, depreciation-of-person, or retirement term. Let W be gross annual wage, b the statutory and customary benefit load (social contributions, paid leave, insurance), C_train the amortized annual cost of recruiting, onboarding, and training, and C_ohL the annual supervision and facility overhead attributable to the role:

> **L_loaded = W * (1 + b) + C_train + C_ohL (8)**

Benefit loads b commonly fall in the 0.25-0.45 range across the regions studied (3, 6, 7). The training term is the amortization of an upfront training investment T over its effective useful life, which is shortened by skill depreciation (Section 5); higher skill-depreciation rates raise annual C_train:

> **C_train = T * [ delta_h / (1 - (1 - delta_h)^Y) ] ,  Y = expected tenure (9)**

To compare with a robot that may cover more than one human shift, we scale by the number of shifts m the robot displaces or augments. The deployment comparator is the ratio of annualized robot cost to loaded labor cost:

> **R = A_robot / (m * L_loaded) (10)**

Interpretation. R < 1 means the robot is cheaper than the loaded labor it covers (automation economically favorable on cost alone); R > 1 means labor is cheaper. The implied simple payback period in years is the one-time robot outlay divided by annual loaded-labor savings net of robot operating/service cost: P = (C_mfg + C_deploy) / max(m*L_loaded - A_service_annual, eps).

Setting R = 1 and solving for the wage yields the break-even loaded labor cost at which a robot exactly pays for itself, a quantity we report by region in Section 6.3:

> **L_breakeven = A_robot / m (11)**

### 4.2 Refined economic parameters and the India base case

To make the framework concrete we adopt a refined parameter set for an India base case; all rupee figures are user-provided modeling anchors (illustrative) and are flagged as such. Indian figures follow the Indian numbering convention: 1 lakh = 100,000 and 1 crore = 10,000,000, and the abbreviation LPA (“lakh per annum”) denotes annual rupee compensation. Thus Rs 10 LPA = 1,000,000 rupees ~ US$12,000 at the Rs 83/US$ rate used throughout, and the robotics-talent band of Rs 3 LPA to Rs 1 crore spans ~US$3,600 to ~US$120,000 per year.

| Parameter | Value (illustrative anchor) | Role in model |
| --- | --- | --- |
| Baseline human (task comparator) | Rs 10 LPA (~ US$12,000) fully costed | m*L_loaded for the displaced/augmented task |
| Robotics talent band (integration/eng.) | Rs 3 LPA - Rs 1 crore (~ $3.6k-$120k) | Feeds C_deploy and labor part of C_service |
| Target ROI / payback | ~ 1.5 years | Decision threshold for favorability |
| Robot useful life (N) | 5 years | Capital-asset service life |
| Robot depreciation delta_r | ~5% / year | Physical capital depreciation (Sec. 5.1) |
| Human-capital depreciation delta_h | ~7% / year | Skill decay, Becker-Mincer (Sec. 5.2) |

Table 4. Refined economic parameters, India base case. Rupee figures are user-provided illustrative anchors.

Talent-band implication. The wide robotics-talent band (Rs 3 LPA to Rs 1 crore) is itself a major driver of deployment cost: integration and ongoing service are labor-intensive, so in markets where senior robotics engineers command Rs 50 lakh-Rs 1 crore, C_deploy and the labor portion of C_service can rival or exceed the hardware. This is a standard labor-economics input — the price of skilled labor — not a depreciation of those engineers. Re-anchoring on N = 5 years and an India Rs 10 LPA baseline tightens the model: under the target ~1.5-year payback, a single-shift robot covering one Rs 10 LPA worker rarely clears the threshold, whereas a robot run multi-shift (m > 1) or covering higher-wage roles does so comfortably.

### 4.3 Worked loaded-labor example: India vs United States

Table 5 contrasts the loaded cost build-up for the India Rs 10 LPA baseline and a representative US manufacturing role, showing how benefits, training, and overhead transform a wage into the comparator that actually faces the robot.

| Component | India (Rs 10 LPA role) | US (manufacturing role) | Note |
| --- | --- | --- | --- |
| Gross wage W | $12,000 | $55,000 | Base |
| Benefit load b | +30% -> $15,600 | +35% -> $74,250 | Eq. 8 |
| Training C_train (amortized) | +$600 | +$3,000 | Eq. 9 |
| Overhead C_ohL | +$1,200 | +$8,000 | Supervision/facility |
| = Loaded labor L_loaded | ~$17,400 | ~$85,250 | Comparator |
| R vs A_robot ($19,300) | 1.11 (labor cheaper) | 0.23 (robot cheaper) | Eq. 10 |

Table 5. Worked loaded-labor build-up, India vs US. The same robot is uneconomical single-shift against the India role but strongly favorable against the US role. Figures illustrative.

## 5. Two distinct depreciation concepts

Both sides of the comparison involve a quantity called depreciation, but the two are conceptually different and must not be conflated. We make the distinction explicit because it is central to this paper's ethical guardrail and because the two rates enter the model in entirely different ways.

### 5.1 Robot depreciation (capital equipment)

The robot is a capital asset, depreciated like heavy machinery at approximately 5% per year, reflecting physical wear and technological obsolescence of the unit. Its book value at year t is:

> **V_robot(t) = C_mfg * (1 - delta_r)^t ,   delta_r ~ 0.05 (12)**

This schedule feeds the end-of-life credit V_eol (Eq. 4) and the refurbish-or-retire rule (Eq. 7). It applies only to the machine and has a salvage value. A 5% reducing-balance schedule is conservative for robotics relative to faster electronics obsolescence, and a reviewer may substitute a steeper schedule; doing so raises A_new in Eq. 7 and shortens economic life, but does not change the qualitative regional gradient.

### 5.2 Human-capital depreciation (skills, not persons)

Critical distinction. Human-capital depreciation in labor economics (Becker; Mincer) refers to the gradual decline in the market value of skills, knowledge, and earning capacity when they are not maintained or updated — skill obsolescence. It is a property of skills, not of people. It is emphatically NOT the depreciation of a person as a disposable asset, and it implies no retirement, scrappage, or salvage value for any human being. We use it only to model how fast training investment must be refreshed.

Consistent with the upper-middle of empirical estimates for technical skills, which depreciate faster than general skills (11, 12), we adopt delta_h ~ 7% per year for robotics-adjacent skills. The retained value of a training investment T at year t is:

> **H(t) = T * (1 - delta_h)^t ,   delta_h ~ 0.07 (13)**

This term enters the labor model only through C_train (Eqs. 8-9): faster skill depreciation means training must be refreshed more often, modestly raising annual training cost. It does not reduce the worker's loaded cost as if they were a wearing-out asset, and it never triggers any retirement rule. The asymmetry delta_h (7%) > delta_r (5%) reflects that technical skills can obsolesce faster than machinery wears. The correct response to that asymmetry is continuous reskilling investment in people — not displacing them. This is precisely the augmentation logic quantified in the cohort analysis that follows.

### 5.3 Why the distinction changes conclusions

Treating skill depreciation as if it were asset depreciation would lead to the false inference that a worker's value declines mechanically toward a salvage point, inviting a retirement rule by analogy with Eq. 7. That inference is both economically wrong — human-capital theory predicts depreciation is offset by experience and reversible through training — and ethically inadmissible. By confining depreciation-with-salvage strictly to the machine and modeling skill decay only as a training-refresh cost, the framework yields the opposite and correct policy implication: faster skill obsolescence is a reason to invest more in people, and it raises, not lowers, the value of the expert cohorts that build and adapt automation.

## 6. Multi-region comparison

We instantiate L_loaded for seven regions using publicly reported labor-cost and wage data (3, 6, 7, 8, 9, 10). Where only a wage or average-earnings figure is available we apply a region-appropriate benefit load and a uniform training/overhead allowance to keep the comparison transparent; all such figures are order-of-magnitude estimates, not precise national accounts. Robot annualized cost is held at the refined five-year central case A_robot ~ US$19,300 per productive year, single-shift (m = 1), unless otherwise noted.

| Region | Loaded labor (US$/yr, est.) | R (5-yr, m=1) | Payback (yr) | R (m=2) | Implication |
| --- | --- | --- | --- | --- | --- |
| United States | 75,000-95,000 | 0.20-0.26 | 0.6-0.9 | 0.10-0.13 | Strongly favorable |
| Australia | 65,000-85,000 | 0.23-0.30 | 0.7-1.0 | 0.11-0.15 | Strongly favorable |
| Europe (EU avg) | 55,000-75,000 | 0.26-0.35 | 0.8-1.2 | 0.13-0.18 | Strongly favorable |
| Other Asia (e.g. China) | 18,000-28,000 | 0.69-1.07 | 2-4 | 0.34-0.54 | Favorable, slower |
| Small-island economies | 10,000-18,000 | 1.07-1.93 | 4->7 | 0.54-0.96 | Marginal / case-by-case |
| Africa (varies widely) | 4,000-12,000 | 1.6-4.8 | >7 | 0.8-2.4 | Often unfavorable single-shift |
| India | 5,000-11,000 | 1.8-3.9 | >7 | 0.9-1.9 | Often unfavorable single-shift |

Table 6. Regional robot-to-labor ratios and payback. Robot annualized cost held at the refined 5-year central case (~US$19,300/productive year). Loaded-labor figures are order-of-magnitude estimates synthesized from OECD, ILO, World Bank, BLS, and national statistics (3, 6, 7, 8, 9, 10). The m=2 column shows the multi-shift case.

### 6.1 Reading the regional results

Robot annualized cost is roughly fixed globally because it is dominated by hardware, integration, and service inputs that trade in international markets; loaded labor cost varies by an order of magnitude across regions. Consequently R rises sharply as wages fall, and the deployment decision flips from clearly favorable in high-wage regions to clearly unfavorable in the lowest-wage regions under single-shift operation, with island and middle-income economies in a case-by-case band. The five-year service life raises every R relative to an eight-year assumption, narrowing the set of clearly favorable single-shift cases.

The m=2 column is decisive: multi-shift operation roughly halves R, moving China firmly into favorable territory and pulling island economies to the margin of favorability. This is the single most important operational lever in low- and middle-wage regions and reframes the deployment question from robot vs one worker to robot vs the loaded labor of all shifts it can cover.

Within-region dispersion is large and frequently exceeds the cross-region gaps shown: a senior, benefits-rich manufacturing role in urban India can approach middle-income loaded costs, while informal or rural labor sits far below the national average. The table should therefore be read as directional structure, not as precise national thresholds.

### 6.2 Per-region assessment

- United States. Loaded manufacturing labor of $75-95k against a fixed ~$19,300 robot cost yields R ~ 0.2-0.26 and sub-year payback even at the five-year life. Automation of automatable task shares is economically compelling across virtually all assumptions; the binding constraints are integration capacity and workforce transition, not cost.
- Australia. Similar to the US with slightly lower loaded costs and a tighter skilled-integration labor market; R ~ 0.23-0.30. High minimum wages and remoteness premiums make automation of routine tasks favorable, though thin local integration talent can raise C_deploy.
- Europe. EU-average loaded labor of $55-75k gives R ~ 0.26-0.35. Favorability is strong but tempered by stringent safety/compliance requirements that raise C_safety within C_deploy and by social frameworks that shape transition obligations.
- Other Asia (e.g. China). With loaded labor of $18-28k, single-shift R straddles 1.0 (0.69-1.07), so favorability is real but sensitive to utilization; under multi-shift operation (R 0.34-0.54) automation is clearly favorable, consistent with the region's leading installation volumes.
- Small-island and small-economy nations. Loaded labor of $10-18k yields single-shift R ~ 1.07-1.93 — generally marginal — but import logistics, scarce service talent, and high downtime cost (Eq. 6) can dominate, making case-by-case assessment essential. Multi-shift use (R 0.54-0.96) is often the deciding factor.
- Africa. Wide dispersion ($4-12k loaded) and high informality push single-shift R to 1.6-4.8; automation is usually uneconomical on cost alone except for hazardous tasks, export-oriented high-duty lines, or where skilled labor is genuinely scarce. The augmentation framing is most relevant here.
- India. The base-case region: loaded labor $5-11k gives single-shift R ~ 1.8-3.9, so a robot rarely meets the ~1.5-year ROI target against one worker. Favorability requires multi-shift operation (R 0.9-1.9), higher-wage roles, quality-critical tasks, or scarcity, again pointing to augmentation rather than wholesale substitution.

### 6.3 Break-even wage by region

Inverting Eq. 11 gives the loaded labor cost at which the robot exactly breaks even (R = 1). Comparing the break-even wage to prevailing loaded labor shows the margin of favorability and how multi-shift operation shifts it.

| Configuration | Break-even loaded labor (R=1) | Regions above break-even (favorable) | Regions below (unfavorable) |
| --- | --- | --- | --- |
| Single-shift (m=1) | ~$19,300/yr | US, Australia, Europe, upper China | India, Africa, islands, lower China |
| Two-shift (m=2) | ~$9,650/yr | + most of China, upper islands | India (lower), much of Africa |
| Three-shift (m=3) | ~$6,430/yr | + much of India/islands | Lowest-wage informal segments |

Table 7. Break-even loaded labor by shift configuration. Each added shift lowers the break-even wage proportionally, expanding the set of regions where automation is favorable.

## 7. AI-vs-skilled-human cohort analysis

The regional comparison treats labor as a single block. In practice, automation competes against differentiated human cohorts that differ in cost, productivity, ramp-up time, and the rate at which their skills depreciate. This section constructs explicit cohorts and compares AI/robotic systems against each on a common basis, then classifies each comparison as displacement, augmentation, or economic infeasibility. Throughout, human-capital depreciation denotes skill decay (Section 5.2), never any retirement of people.

### 7.1 Cohort definitions

We define three skill-tier cohorts of robotics-AI human talent, anchored on the India talent band (Table 4), and the AI/robotic system as a fourth machine cohort for comparison. Each human cohort is characterized by loaded cost, the task mix it performs, productivity, ramp-up time to full productivity, and skill-depreciation rate.

| Cohort | Loaded cost (US$/yr, est.) | Representative tasks | Ramp-up to full productivity | Skill depreciation delta_h |
| --- | --- | --- | --- | --- |
| Entry robotics-AI (Rs 3-6 LPA) | 4,500-9,000 | Teleoperation (teleop), data labeling, basic maintenance, monitoring | 1-3 months | ~9% (specific skills) |
| Mid robotics-AI (Rs 15-40 LPA) | 22,000-60,000 | Integration, programming, fleet ops, validation | 6-12 months | ~7% |
| Expert robotics-AI (Rs 60L-1 cr) | 85,000-140,000 | Architecture, autonomy R&D, safety case, novel deployment | 18-36 months | ~5% (general+deep) |
| AI/robotic system (machine) | 19,300 (A_robot, 5-yr) | Repetitive perception/manipulation at high duty | Weeks (integration) + retrain per task | delta_r ~5% physical |

Table 8. Cohort definitions. Human loaded costs derive from the India talent band (illustrative anchors); the machine cohort uses the refined 5-year A_robot. Skill-depreciation rates follow the technical-skill literature (11, 12) and are higher for narrow/specific skills.

### 7.2 Cohort cost-productivity comparison

Cost alone is misleading without productivity and ramp-up. We normalize by a productivity index (relative throughput on the cohort's core automatable tasks, machine = 1.0 reference on repetitive tasks) and report a cost-per-normalized-output and a break-even relationship against the machine cohort.

| Comparison (machine vs cohort) | Cost ratio (machine/human) | Productivity note | Break-even / payback | Outcome class |
| --- | --- | --- | --- | --- |
| vs Entry cohort | 2.1-4.3x (machine costlier) | Machine faster on repetitive tasks; humans flexible | Rarely pays single-shift; pays multi-shift | Augment (often uneconomical to replace) |
| vs Mid cohort | 0.32-0.88x (machine cheaper) | Machine handles repetitive subset; mid does integration | 1-2.5 yr on automatable task share | Augment; partial task displacement |
| vs Expert cohort | 0.14-0.23x (machine far cheaper) | Non-overlapping: experts create/deploy systems | N/A - complementary | Augment / complement (not substitutable) |

Table 9. Cohort cost-productivity comparison. Cost ratio is machine annualized cost divided by cohort loaded cost; <1 means the machine is cheaper. Outcomes classify the economically rational relationship, not a mandate to replace anyone.

### 7.3 Ramp-up, depreciation, and the time dimension

Ramp-up time and depreciation reshape the static cost picture. The machine cohort reaches productive use in weeks once integrated but must be re-engineered or retrained for each new task, and depreciates physically at ~5%/yr. The entry human cohort ramps in weeks-to-months and is highly flexible across tasks, but its narrow technical skills depreciate fastest (~9%/yr) absent training. Mid and expert cohorts take months to years to reach full productivity — a large embedded investment — but their broader, deeper skills depreciate more slowly and, critically, are the cohorts that build and maintain the machines.

This yields an asymmetry central to the augmentation thesis: machines are cheap on narrow repetitive tasks but cannot self-deploy; expert humans are expensive but irreplaceable for deployment and adaptation. The economically optimal configuration is therefore almost never machine instead of human cohort but machine for the automatable task share, freeing each human cohort toward higher-value tasks, with continuous reskilling to offset delta_h. Faster skill depreciation is an argument for more training investment in people, not for their removal.

### 7.4 Worked cohort break-even example

Consider the mid cohort at $40,000 loaded, performing a role of which 50% is repetitive (automatable) and 50% is integration/judgment (non-automatable). The machine at $19,300/yr can cover the automatable half at higher throughput. The automatable task share is worth ~$20,000/yr of loaded labor; the machine covering it at $19,300 yields R ~ 0.97 on that share single-shift, improving to ~0.48 at two shifts. The rational outcome is to automate the repetitive half and redeploy the engineer onto the integration half plus oversight of additional machines — raising the engineer's effective leverage rather than removing the role. Full-role displacement would require the machine to also perform the non-automatable half, which it cannot, so displacement is not economical even though the automatable share is.

### 7.5 Regional-cohort outcome matrix

Combining region (wage level) with cohort (skill tier) gives the operational decision. Each cell states the dominant economically rational outcome for the automatable task share, single-shift; multi-shift operation shifts cells one step toward displacement.

| Cohort \ Region | High-wage (US/EU/AU) | Mid-wage (China/islands) | Low-wage (India/Africa) |
| --- | --- | --- | --- |
| Entry | Augment; partial displace | Augment | Hire (automation uneconomical) |
| Mid | Displace routine; augment | Augment; partial displace | Augment |
| Expert | Complement (demand rises) | Complement | Complement |

Table 10. Regional-cohort outcome matrix (single-shift). Outcomes describe economically rational task-level configurations, not mandates to replace people; expert cohorts are complementary everywhere.

### 7.6 Per-cohort outcome summary

- Entry cohort - augment / often uneconomical to replace. At entry-cohort loaded costs (US$4.5-9k), the machine is 2-4x more expensive single-shift; replacement is rarely economical, and the rational use is to assign machines to the most repetitive, high-duty subset while entry staff move to supervision, exception handling, and data tasks.
- Mid cohort - augment with partial task displacement. The machine is cheaper than the mid cohort on the automatable task share, with 1-2.5-year payback on that share. The rational outcome is task-level automation that raises mid-cohort leverage (one engineer overseeing a larger fleet), not headcount substitution.
- Expert cohort - complement, not substitute. Expert tasks (architecture, autonomy R&D, safety cases) do not overlap with machine capability; the cohorts are complementary, and greater automation typically increases demand for expert talent that designs and governs it.
Summary. Across cohorts, the dominant economically rational outcome is augmentation — automating task shares rather than replacing people — with full single-worker displacement economical mainly for narrow, high-duty, high-wage, multi-shift cases. This is an economic finding about tasks and prices; it is not a statement about the value of any cohort of workers.

## 8. Deployment decision framework

The preceding sections combine into an operational decision procedure. Given a candidate task, region, and cohort, the operator proceeds in sequence:

- Step 1 - Task decomposition. Split the role into automatable and non-automatable task shares; only the automatable share competes with the machine.
- Step 2 - Compute A_robot. Apply Eqs. 1-6 with site-specific deployment, service multiplier, life, and utilization to obtain the annualized robot cost.
- Step 3 - Compute loaded labor for the automatable share. Apply Eq. 8 to the displaced/augmented task share, scaled by shifts m the machine can cover.
- Step 4 - Evaluate R and payback. If R < 1 and payback <= target ROI, the automatable share is favorable; otherwise re-test under multi-shift (raise m) before rejecting.
- Step 5 - Classify outcome. Map to displace / augment / hire using the regional-cohort matrix (Table 10); reserve expert-cohort time for integration and governance.
- Step 6 - Apply non-cost and ethical checks. Layer quality, safety, option value, and the social obligations of any workforce transition; a favorable R is necessary but not sufficient to justify displacement.
The framework deliberately makes multi-shift utilization the pivotal lever (Steps 4) and treats human impact as a binding non-cost constraint (Step 6), reflecting that the model prices deployment but does not, and should not, decide the human consequences alone.

## 9. Sensitivity and scenario analysis

### 9.1 One-at-a-time sensitivity

We vary the most consequential parameters around the refined five-year central case (A_robot ~ US$19,300/productive year), one at a time, reporting the resulting annualized robot cost and direction of effect on R.

| Parameter | Range tested | Effect on A_robot | Notes |
| --- | --- | --- | --- |
| Utilization U | 0.40 -> 0.95 | ~$33.8k -> ~$14.2k | Dominant lever; idle assets are expensive |
| Service multiplier s | 1x -> 2x | ~$16.2k -> ~$22.4k | Second-largest lever |
| Service life N | 5 -> 12 yr | ~$19.3k -> ~$9.0k | Longer life lowers annualized cost steeply |
| BOM / C_mfg | -30% -> +30% | ~$17.8k -> ~$20.8k | Weak lever; hardware is minority of TCO |
| Shifts covered m | 1 -> 3 | R / 1 -> R / 3 | Acts on denominator; powerful in low-wage regions |

Table 11. One-at-a-time sensitivity around the refined central case.

### 9.2 Two-way sensitivity: utilization x wage

Because utilization and wage are the two widest levers, Table 12 reports R jointly across both, holding other central assumptions. Cells with R < 1 (favorable) are the deployment-favorable region of the parameter space.

| Loaded labor \ U | U=0.5 (A=$27k) | U=0.7 (A=$19.3k) | U=0.9 (A=$15k) |
| --- | --- | --- | --- |
| $10k (low) | 2.70 | 1.93 | 1.50 |
| $20k (mid) | 1.35 | 0.97 | 0.75 |
| $40k (upper-mid) | 0.68 | 0.48 | 0.38 |
| $80k (high) | 0.34 | 0.24 | 0.19 |

Table 12. Two-way sensitivity of R to utilization and loaded labor (single-shift, m=1). Favorability (R<1) appears only at mid-to-high wages unless utilization is high; multi-shift operation would shift the favorable region downward in wage.

### 9.3 Scenario analysis

We combine parameters into three coherent scenarios to bound the result, evaluated for a mid-wage region (loaded labor US$23k):

| Scenario | Assumptions | A_robot | R (m=1) | R (m=2) |
| --- | --- | --- | --- | --- |
| Optimistic | N=10, U=0.9, s=1.0, low deploy | ~$8.0k | 0.35 | 0.17 |
| Central | N=5, U=0.7, s=1.5, mid deploy | ~$19.3k | 0.84 | 0.42 |
| Pessimistic | N=5, U=0.5, s=2.0, high deploy | ~$31k | 1.35 | 0.67 |

Table 13. Scenario analysis at mid-wage loaded labor (US$23k). Even the pessimistic case becomes favorable under multi-shift operation.

### 9.4 Dominant levers and the tornado ordering

Ranking parameters by their swing in A_robot (a tornado ordering) gives, from most to least influential: utilization, shifts covered (via the denominator of R), service life, service multiplier, then BOM. Two operational implications follow. First, keeping assets highly utilized — ideally multi-shift — is the single most effective way to make automation favorable, especially in mid- and low-wage regions. Second, because service cost scales with manufactured cost, design-for-serviceability and a lower service multiplier do more for deployment economics than shaving the BOM. Wage level enters only through the denominator of R but with the widest range of all, which is exactly why the deployment decision is regional and cohort-specific.

## 10. Macro analysis: robot penetration relative to the global workforce

Scaling from a single deployment decision to the global picture clarifies how far automation has actually penetrated. According to the IFR World Robotics 2025 report, the worldwide operational stock of industrial robots reached approximately 4.66 million units in 2024, up about 9% year-on-year, with roughly 542,000 new installations in that year and growth projected past 700,000 annual installations by 2028 (13). China alone surpassed 2 million units in operational stock and accounts for over half of new installations (13).

Relating this stock to a world population of about 8.2 billion (UN/World Bank, 2024) yields a robot-penetration ratio:

> **rho = robots / population = 4.66M / 8.2B ~ 1 robot per ~1,760 people  (~0.57 per 1,000) (14)**

| Metric | Value (cited / derived) | Notes |
| --- | --- | --- |
| Operational stock, industrial robots (2024) | ~4.66 million units | IFR World Robotics 2025 (13) |
| New installations (2024) | ~542,000 units/yr | IFR (13) |
| Projected installations (2028) | >700,000 units/yr | IFR (13) |
| World population (2024) | ~8.2 billion | UN / World Bank (9, 14) |
| Robots per 1,000 people | ~0.57 | Derived (Eq. 14) |
| Global labor force | ~3.6 billion | World Bank / ILO (9) |
| Robots per 1,000 workers | ~1.3 | Derived |

Table 14. Robot penetration relative to global population and workforce. Industrial robots only; service and mobile robots would raise the base.

Even after a decade in which installations doubled, the installed industrial-robot base is on the order of one unit per ~1,760 people and roughly 1.3 per 1,000 workers — small relative to the global workforce. This matters for the deployment thesis in two ways. First, penetration is highly concentrated: with China holding over 40% of operational stock, global averages understate density in high-wage manufacturing and overstate it everywhere else. Second, the macro ratio is consistent with the micro model: because robot annualized cost is roughly fixed globally while loaded labor varies by an order of magnitude, diffusion has been fastest exactly where R is lowest — high-wage, high-utilization manufacturing.

The macro picture also reinforces the augmentation reading of Section 7. At current and projected penetration, robots are nowhere near the density that wholesale workforce substitution would require; their growth is concentrated in specific high-duty tasks within specific high-wage settings. These figures describe machine deployment density — not any ratio of machines that should replace people.

## 11. Discussion

### 11.1 Where automation is economically favorable

The model yields a clear, jointly regional-and-cohort gradient. In high-wage regions a representative service-class robot reaches annualized parity quickly — typically well under two years even at the refined five-year life — so automation of automatable task shares is economically favorable across most assumptions. In upper-middle-income economies it remains favorable but with payback of a few years, highly sensitive to utilization and shift coverage. In India, much of Africa, and many small-island economies, loaded labor is low enough that single-shift automation often does not reach parity within the five-year life; favorability there depends on multi-shift utilization, tasks where labor is scarce or hazardous, or quality benefits not captured by cost.

The cohort analysis sharpens this into actionable guidance: automate the most repetitive, high-duty task shares; reserve mid- and expert-cohort time for integration, governance, and adaptation; and invest continuously in reskilling to offset the faster depreciation of narrow technical skills. The dominant rational outcome is augmentation, with full displacement economical mainly in narrow, high-wage, multi-shift niches.

### 11.2 Policy implications

For policymakers, the regional gradient implies that automation-driven labor displacement pressure is concentrated in high-wage economies and in high-duty export sectors of middle-income economies, not uniformly distributed. Reskilling and transition policy is therefore most urgent where R is lowest and utilization highest. The human-capital framing also argues for public investment in continuous technical training: because narrow skills depreciate fastest, the social return to reskilling is high, and it is the mechanism by which workers move up the cohort ladder toward the complementary, automation-resistant expert tier rather than being displaced from it.

### 11.3 Firm-level strategy

For firms, the dominant levers (utilization, shift coverage, serviceability) are partly within managerial control, unlike wage levels. The framework implies that the highest-return automation investments pair high-duty, multi-shift deployment with design-for-serviceability and second-sourced supply chains, and that workforce strategy should aim to raise cohort leverage — fewer routine tasks per engineer, more fleet oversight — rather than headcount reduction, which the cohort analysis shows is rarely the economically optimal configuration outside narrow niches.

### 11.4 Limitations

- Cost-only scope. The model compares deployment cost, not value. It omits quality, throughput consistency, safety in hazardous tasks, strategic option value, and worker wellbeing, any of which can dominate the decision.
- Data dispersion. Regional and cohort loaded-labor figures are order-of-magnitude estimates; within-region and within-cohort variation can exceed the gaps shown.
- Anchor uncertainty. The robot BOM, the India rupee anchors, and the Ati Robotics datapoint are user-provided and illustrative, not independently verified. Vendor names in the BOM are representative, not endorsements or price quotes.
- Static prices and rates. Wages, energy, hardware, and depreciation rates move over time and across studies; the comparison is a snapshot, not a forecast. Human-capital depreciation estimates in particular span a wide empirical range.
- Productivity normalization. Cohort productivity indices are illustrative; rigorous task-level time-and-motion data would refine the break-even points.

### 11.5 Ethical note

An economic cost ratio is not a measure of human worth. The ratio R and the cohort comparisons price machines against labor in a market; they say nothing about the value, dignity, or productivity of any person. Lifecycle, depreciation, refurbishment, and retirement reasoning in this paper apply only to capital equipment. Human-capital depreciation denotes skill decay and motivates investment in people, never their removal. A finding that labor is cheaper than a robot is a statement about wages and equipment prices; a finding that a robot is cheaper on some task share does not imply that displacing people is justified. Deployment decisions that affect employment carry social obligations — transition support, retraining, and fair process — that fall outside any cost model and must be weighed separately.

### 11.6 Future work

Three extensions would strengthen the framework. First, empirical calibration of the service multiplier and productivity indices using fleet telemetry and task-level time-and-motion studies would replace modeled ranges with measured distributions. Second, a dynamic version that lets wages, hardware prices, and penetration evolve over time would convert the snapshot into a diffusion forecast. Third, integrating non-cost value (quality, safety, option value) and explicit transition-cost accounting would move the output from a cost ratio toward a fuller social cost-benefit measure, while preserving the strict separation between capital depreciation and human-capital (skill) depreciation that this paper insists upon.

## 12. Conclusion

Deployment economics, not acquisition cost, now governs the robot-versus-labor decision. By modeling robot TCO as manufactured cost plus deployment plus a service multiple — with an explicit BOM and supply-chain decomposition, a refurbish-or-retire rule for the capital asset, and physical depreciation — and by comparing it against properly loaded labor cost with skill (not person) depreciation, we obtain a transparent, fully parameterized framework that a reviewer can re-run with their own inputs.

Applied across seven regions and three skill cohorts, the framework shows that automation favorability is strongly regional and cohort-specific: rapid payback in high-wage economies and for high-duty task shares, multi-year payback in upper-middle-income economies, and frequently no within-life parity in the lowest-wage, single-shift cases. Utilization and shift coverage — not BOM — are the dominant levers, and design-for-serviceability matters more than hardware price. The dominant rational outcome across cohorts is augmentation rather than wholesale displacement, with global penetration (~0.57 robots per 1,000 people) far below any substitution threshold. The broader implication is that the pace and geography of automation will be set less by hardware progress than by where operators can sustain high utilization and multi-shift duty against the local price of labor. Two questions remain open. First, the model rests on illustrative service multipliers and productivity indices; calibrating both from fleet telemetry and task-level time-and-motion data would replace assumed ranges with measured distributions. Second, the analysis is a static snapshot; letting wages, hardware prices, and penetration evolve would convert it into a diffusion forecast and test whether the regional gradient narrows as low-wage economies industrialize.

Finally, these are statements about prices, not people. The model captures deployment cost only; human-capital depreciation denotes the decay of skills and is an argument for investing in people, not for retiring them. None of the results should be read as a judgment of human worth.

## References and Notes

1. AMD Machines, Total cost of ownership for robotic systems: beyond the purchase price, industry analysis (2025); https://amdmachines.com/blog/total-cost-of-ownership-for-robotic-systems/.

2. Robotomated, Annual robot maintenance costs: what to budget beyond the purchase price (2025); https://robotomated.com/learn/cost/robot-maintenance-cost-annual.

3. OECD, Labour compensation per hour worked (indicator), OECD Data (2025); https://www.oecd.org/en/data/indicators/labour-compensation-per-hour-worked.html.

4. FMC Group, Average cost per employee: global statistics (2026); https://fmcgroup.com/average-cost-per-employee/.

5. EVS International, How much does an industrial robot cost? Pricing guide (2026); https://www.evsint.com/how-much-does-an-industrial-robot-cost-pricing-guide-2026/.

6. U.S. Bureau of Labor Statistics, Employer Costs for Employee Compensation and International comparisons of hourly compensation costs in manufacturing; https://www.bls.gov/fls/ichcc.htm.

7. International Labour Organization, Global Wage Report 2024-25, ILO, Geneva (2024); https://www.ilo.org/sites/default/files/2024-11/GWR-2024_Layout_E_RGB_Web.pdf.

8. Destatis (German Federal Statistical Office), Hourly compensation costs in manufacturing and Labour cost per hour worked, EU comparison (2024-25); https://www.destatis.de/EN/Themes/Countries-Regions/International-Statistics/Data-Topic/Tables/BasicData_LaborCosts.html.

9. World Bank, Open Data (GDP per capita; labor force; wage and salaried workers, modeled ILO estimates) (2024-25); https://data.worldbank.org/.

10. Amrep Mexico, 2025 manufacturing cost breakdown: China vs Thailand vs India; https://www.amrepmexico.com/blog/manufacturing-cost-comparison-china-thailand-india. Island-economy wage figures from Fiji Bureau of Statistics / wage.is (2024-26).

11. G. S. Becker, Human Capital (1964); J. Mincer, Schooling, Experience, and Earnings (1974); M. Gregory et al., Human capital depreciation and returns to experience, American Economic Review (2022); https://www.aeaweb.org/articles?id=10.1257/aer.20201571.

12. S. Walter, J.-D. Lee, How susceptible are skills to obsolescence? A task-based perspective of human capital depreciation, Foresight and STI Governance (2024); https://foresight-journal.hse.ru/article/view/19223.

13. International Federation of Robotics (IFR), World Robotics 2025 - Industrial Robots, Executive Summary (2025); https://ifr.org/img/worldrobotics/Executive_Summary_WR_2025_Industrial_Robots.pdf.

14. United Nations, World Population Prospects (2024); https://population.un.org/wpp/.

15. User-provided illustrative datapoint: Ati Robotics - ~231 robots deployed worldwide; ~US$41M raised through Series B. Not independently verified; used for scale only.

## Acknowledgments

The author thanks colleagues for discussion. Funding: this work received no external funding. Author contributions: S.B. conceived the study, developed the cost model and cohort framework, performed all analysis, and wrote the manuscript. Competing interests: S.B. is a former employee of Ati Robotics, which appears in this paper only as an illustrative, user-provided, and independently unverified datapoint (Section 2.5; reference 15) and is not used as a model input. The author declares no other competing interests. Data and materials availability: all equations, parameters, and data sources are provided in the main text and appendices, and every result can be recomputed from the equations in Appendix B. All modeling assumptions and illustrative/user-provided figures are flagged in-text; readers are encouraged to substitute verified local data, vendor quotes, and task-level productivity measurements before drawing operational conclusions.

Use of AI-assisted technology. The author used Anthropic’s Claude (model Claude Opus 4.8, accessed via Claude Code; July 2026) as an aid in copy-editing and presentation of this manuscript — specifically for line-editing toward clear, declarative, active-voice prose; defining terminology and units (for example, lakh, crore, and LPA) on first use; and drafting a small number of clarifying sentences that the author reviewed, verified, and approved. No AI tool generated research data, results, citations, or images, and no AI tool is an author. The author is solely responsible for all content and for guarding against AI-introduced error or bias. Full details, including the verbatim prompt, appear in Appendix D.

## Appendix A. Notation glossary

| Symbol | Meaning | Typical value / unit |
| --- | --- | --- |
| C_BOM | Bill of materials cost | $11,400 (illustrative) |
| C_oh | Manufacturing overhead | ~35% of BOM |
| C_mfg | Manufactured cost (BOM + overhead) | $15,400 |
| C_deploy | Deployment / integration (one-time) | $10k-50k |
| s | Service multiplier | 1x-2x of C_mfg |
| C_service | Lifetime service & maintenance | s x C_mfg |
| C_energy, C_downtime | Operating costs | Eq. 6 |
| V_eol | End-of-life credit (capital asset) | $ (salvage/refurb) |
| N, U | Service life; utilization | 5 yr; 0.7 |
| A_robot | Annualized robot cost | $19,300/yr (5-yr) |
| W, b | Gross wage; benefit load | $; 0.25-0.45 |
| C_train, C_ohL | Training; labor overhead | Eq. 8-9 |
| L_loaded | Loaded labor cost | $/yr |
| m | Shifts covered by one robot | 1-3 |
| R | Robot-to-labor cost ratio | A_robot/(m*L_loaded) |
| delta_r, delta_h | Robot / human-capital depreciation | ~5%; ~7% |

Table A1. Notation glossary.

## Appendix B. Equation summary

| Eq. | Expression | Purpose |
| --- | --- | --- |
| 1 | C_mfg = C_BOM + C_oh | Manufactured cost |
| 2 | C_deploy = integration + safety + programming + fixturing | One-time deployment |
| 3 | C_service = s * C_mfg | Lifetime service |
| 4 | TCO = C_mfg + C_deploy + C_service + C_energy + C_downtime - V_eol | Lifetime TCO |
| 5 | A_robot = TCO / (N * U) | Annualized robot cost |
| 6 | C_op = (P_kW*h*lambda*N) + (d*L_hourly*N) | Operating cost |
| 7 | Refurbish if C_refurb/(N_r*U) < A_new | Refurbish-or-retire (capital only) |
| 8 | L_loaded = W*(1+b) + C_train + C_ohL | Loaded labor cost |
| 9 | C_train = T*[delta_h/(1-(1-delta_h)^Y)] | Training amortization |
| 10 | R = A_robot/(m*L_loaded) | Decision ratio |
| 11 | L_breakeven = A_robot/m | Break-even wage |
| 12 | V_robot(t) = C_mfg*(1-delta_r)^t | Robot depreciation |
| 13 | H(t) = T*(1-delta_h)^t | Skill (human-capital) decay |
| 14 | rho = robots/population | Penetration ratio |

Table B1. Equation summary. Eqs. 7 and 12 (refurbish/retire, depreciation-with-salvage) apply to capital equipment only; Eq. 13 models skill decay, never retirement of persons.

## Appendix C. Data sources and assumptions register

| Input | Class | Source / basis |
| --- | --- | --- |
| Robot BOM (Rs 9.5 lakh) | Illustrative (user) | User-provided anchor |
| Ati Robotics 231 units / $41M | Illustrative (user) | User-provided, unverified |
| India rupee anchors (Rs 10 LPA, talent band, ROI, life) | Illustrative (user) | User-provided |
| TCO multiple, maintenance %, deployment range | Fact (cited) | Refs 1, 2, 5 |
| Regional loaded labor | Fact-derived (est.) | Refs 3, 6, 7, 8, 9, 10 |
| Human-capital depreciation ~7% | Fact-derived (est.) | Refs 11, 12 |
| IFR operational stock 4.66M | Fact (cited) | Ref 13 |
| World population 8.2B; labor force 3.6B | Fact (cited) | Refs 9, 14 |
| Overhead %, utilization, service multiplier | Assumption | Modeling choice (sensitized) |

Table C1. Register of inputs by class. Load-bearing conclusions rely on cited facts; illustrative/user-provided figures are flagged throughout and excluded from verified claims.

## Appendix D. Methodology and conversion notes

Currency conversions use Rs 83/US$ throughout and are rounded to the nearest hundred dollars or thousand rupees as appropriate. Lakh and crore follow the Indian numbering convention (1 lakh = 100,000; 1 crore = 10,000,000). Loaded-labor estimates apply a region-appropriate benefit load b within 0.25-0.45 and a uniform training/overhead allowance to maintain cross-region comparability; readers with access to national accounts should substitute local figures. Robot annualized cost is computed per productive year (dividing by N x U), so it is directly comparable to annual loaded labor. Ratios R and payback figures are rounded and should be read as directional. Productivity indices in the cohort analysis are illustrative normalizations (machine = 1.0 on repetitive tasks) pending task-level measurement. All equations are deterministic; no stochastic simulation is used, and sensitivity is explored by parameter sweeps (Section 9). The strict guardrail separating capital depreciation (Eqs. 7, 12) from human-capital skill decay (Eq. 13) is maintained in every computation: no human quantity carries salvage value, a retirement trigger, or a scrappage term.

AI-assisted writing disclosure. Tool: Anthropic Claude, model Claude Opus 4.8 (model identifier claude-opus-4-8), accessed through the Claude Code interface in July 2026. Scope of use: editorial revision of an existing author-written draft (tracked-changes line edits, terminology and unit glossing, passive-to-active conversions) and drafting of a small number of clarifying sentences, all reviewed and approved by the author. The tool did not produce data, analyses, references, or figures. The verbatim prompt provided to the tool was: “Act as a senior academic editor specializing in robotics and engineering. Review the following draft section for a Science Robotics manuscript. Ensure your edits enforce clear, declarative writing that avoids passive voice, oversimplification, and needless jargon. Here are my specific instructions: Ensure all measurements are written in SI units. Adopt a broadly accessible but highly technical tone so readers outside my exact robotics sub-discipline can understand the core innovations. Emphasize the broader implications of this work and state any unresolved questions or future prospects. Ensure all terminology is defined on first use.” A follow-up instruction directed the tool to deliver targeted tracked-changes edits to the front matter and key sections, systemic terminology and unit fixes, and an editorial memo. The manuscript draft, all numerical inputs, and all cited sources were author-provided; the author reviewed every AI-suggested change and accepts full accountability for the final text.

## Appendix E. Detailed per-region loaded-labor build-up

Table E1 makes the regional loaded-labor estimates of Section 6 transparent by showing the gross wage, benefit load, training, and overhead components used to derive each region's L_loaded. All figures are order-of-magnitude estimates synthesized from cited sources (3, 6, 7, 8, 9, 10) and should be replaced with verified national accounts for operational use.

| Region | Gross wage W | Benefit load b | Training + overhead | L_loaded (est.) | Break-even gap vs $19.3k |
| --- | --- | --- | --- | --- | --- |
| United States | $55,000-70,000 | 0.35 | +$11,000 | 75,000-95,000 | Far above (favorable) |
| Australia | $48,000-62,000 | 0.30 | +$9,000 | 65,000-85,000 | Far above (favorable) |
| Europe (EU avg) | $40,000-55,000 | 0.35 | +$8,000 | 55,000-75,000 | Above (favorable) |
| Other Asia (China) | $13,000-20,000 | 0.35 | +$3,500 | 18,000-28,000 | Near / above (m-dependent) |
| Small-island | $7,500-13,000 | 0.28 | +$2,200 | 10,000-18,000 | Near / below (marginal) |
| Africa | $3,000-9,000 | 0.25 | +$1,200 | 4,000-12,000 | Below (unfavorable single-shift) |
| India | $3,800-8,500 | 0.30 | +$1,000 | 5,000-11,000 | Below (unfavorable single-shift) |

Table E1. Per-region loaded-labor build-up (Eq. 8). Components are illustrative estimates; the final column compares L_loaded to the single-shift break-even of ~$19,300.

The build-up shows that benefit loads are relatively similar across regions (0.25-0.35), so the order-of-magnitude dispersion in loaded labor is driven primarily by gross wages, not by benefit structure. Training and overhead scale with wage and are a small absolute amount in low-wage regions, which is itself a reason automation's fixed integration cost weighs more heavily there: the same $25,000 deployment is a larger multiple of annual loaded labor in India than in the United States.

## Appendix F. Worked operating-cost and refurbish-or-retire examples

### F.1 Operating cost (Eq. 6)

For the central robot drawing P_kW = 1.2 kW over h = 4,000 productive hours per year at a tariff lambda = $0.10/kWh, annual energy cost is 1.2 x 4,000 x 0.10 = $480/yr, or $2,400 over five years. With d = 60 downtime hours per year and a downtime cost L_hourly = $12/hr (idle dependent labor and lost output), downtime cost is 60 x 12 = $720/yr, or $3,600 over five years. Combined operating cost ~$6,000 over the life, the figure used in Table 3. Downtime, not energy, dominates operating cost, which is why reliability and serviceability (Section 3.5) matter more than power efficiency for deployment economics.

### F.2 Refurbish-or-retire (Eq. 7)

At the end of year 5, suppose a refurbishment costing C_refurb = $18,000 would restore residual life N_r = 3 years at utilization U = 0.7, giving an annualized refurbished cost of 18,000 / (3 x 0.7) = $8,571/productive year. A new replacement has A_new ~ $19,300/productive year. Since $8,571 < $19,300, the rule retains and refurbishes the existing asset. This calculation applies only to the capital equipment; no analogous computation is ever applied to human labor.

| Option | Cost | Residual life | Annualized | Decision |
| --- | --- | --- | --- | --- |
| Refurbish | $18,000 | 3 yr @ U=0.7 | $8,571/yr | Chosen (cheaper) |
| Retire & replace | full new TCO | 5 yr @ U=0.7 | $19,300/yr | Rejected |

Table F1. Refurbish-or-retire worked example (capital equipment only).

## Appendix G. Extended two-way sensitivity grids

Tables G1 and G2 extend the two-way utilization-by-wage grid of Section 9.2 to two- and three-shift operation, showing how multi-shift coverage expands the favorable (R < 1) region downward in wage.

Two-shift (m = 2).

| Loaded labor \ U | U=0.5 | U=0.7 | U=0.9 |
| --- | --- | --- | --- |
| $10k | 1.35 | 0.97 | 0.75 |
| $20k | 0.68 | 0.48 | 0.38 |
| $40k | 0.34 | 0.24 | 0.19 |
| $80k | 0.17 | 0.12 | 0.09 |

Table G1. R under two-shift operation. Favorability (R<1) now reaches $20k loaded labor at moderate utilization.

Three-shift (m = 3).

| Loaded labor \ U | U=0.5 | U=0.7 | U=0.9 |
| --- | --- | --- | --- |
| $10k | 0.90 | 0.64 | 0.50 |
| $20k | 0.45 | 0.32 | 0.25 |
| $40k | 0.23 | 0.16 | 0.13 |
| $80k | 0.11 | 0.08 | 0.06 |

Table G2. R under three-shift operation. At three shifts even $10k loaded labor becomes favorable at moderate utilization, explaining why automation penetrates low-wage regions selectively where round-the-clock duty is possible.

These grids quantify the central operational finding: the favorable region of the parameter space is governed jointly by utilization and shift coverage, and multi-shift duty is the mechanism by which automation becomes economical even where wages are low. They also caution that the converse holds: a robot run a single low-utilization shift in a low-wage region is uneconomical across the entire grid.

## Appendix H. Illustrative deployment vignettes

The following hypothetical vignettes illustrate how the framework resolves concrete decisions across region and cohort. They are illustrative compositions, not case studies of specific firms.

### H.1 High-wage, mid-cohort, multi-shift (favorable, displace routine)

A US contract manufacturer runs a two-shift line where a mid-cohort technician ($85k loaded) spends half their time on repetitive machine-tending. A robot at $19,300/yr covering the repetitive share across both shifts yields R ~ 0.11 on that share. The rational outcome is to automate machine-tending and redeploy the technician to changeovers, quality, and oversight of two additional cells. Payback is under a year; the binding constraint is integration scheduling, not cost.

### H.2 Low-wage, entry-cohort, single-shift (uneconomical, hire)

An Indian workshop considers automating a single-shift packing task currently done by an entry-cohort worker ($6k loaded). The robot at $19,300/yr gives R ~ 3.2 — far above 1 — and payback exceeds the asset life. Automation is uneconomical; the rational outcome is to continue with human labor and, if scale grows, revisit under multi-shift duty. No notion of retiring the worker arises; the question is purely whether the machine is a cheaper way to do the task, and it is not.

### H.3 Mid-wage, hazardous task, single-shift (favorable on non-cost grounds)

A mid-wage island chemical handler faces a hazardous task with loaded labor of $15k. On cost alone R ~ 1.3 (marginally unfavorable), but the task's safety risk and the scarcity of trained handlers tip the decision: the non-cost value of removing humans from a hazardous environment (Step 6 of the decision framework) justifies deployment even though R > 1. This vignette shows why a favorable R is sufficient but not necessary — and why human-impact considerations can also point toward automation when they protect workers.

## Appendix I. Productivity, quality, and non-cost value

The core model compares cost; this appendix sketches how non-cost value enters a fuller assessment. Three factors most often dominate cost in practice:

- Throughput consistency. Machines hold tact time without fatigue, raising effective throughput on repetitive tasks above the human baseline and improving on-time delivery. Where this consistency relaxes a bottleneck, its value can exceed the entire labor saving.
- Quality and defect reduction. Reduced variance lowers scrap and rework. For high-value output, a one-point defect-rate improvement can outweigh a year of loaded labor, shifting marginal cases (R near 1) toward deployment independent of wage.
- Safety and hazardous-task removal. Removing humans from hazardous tasks carries value that is real but not captured by R; as in vignette H.3, it can justify deployment at R > 1 and, importantly, does so in a way that protects workers rather than displacing them from desirable roles.
- Flexibility and option value. Reprogrammable platforms carry option value across future product changes; conversely, humans retain flexibility advantages on non-routine and exception tasks, which is why the cohort analysis assigns judgment-heavy shares to people.
A complete deployment appraisal would add these as monetized adjustments to the numerator and denominator of R. Because they generally favor deployment for quality- and safety-critical tasks, the cost-only R reported here is a conservative lower bound on automation favorability for such tasks, and a fair estimate for purely repetitive, commodity tasks.

| Non-cost factor | Typical direction | When it dominates |
| --- | --- | --- |
| Throughput consistency | Favors machine | Bottleneck / high-demand lines |
| Quality / defect reduction | Favors machine | High-value or precision output |
| Safety (hazard removal) | Favors machine | Hazardous tasks (protects workers) |
| Flexibility on exceptions | Favors human | Non-routine, variable tasks |
| Option value | Context-dependent | Frequent product changeovers |

Table I1. Non-cost factors and their typical effect on the deployment decision.

## Appendix J. Supply-chain shock propagation

Because service cost is a multiple of manufactured cost (Eq. 3), a BOM shock propagates into lifetime TCO with leverage. Table J1 traces a 20% price shock to the compute subsystem (illustratively ~22% of BOM) through to A_robot, showing why supply-chain risk in concentrated subsystems matters more than its direct BOM share suggests.

| Quantity | Baseline | After +20% compute shock | Change |
| --- | --- | --- | --- |
| Compute share of BOM | ~$2,500 | ~$3,000 | +$500 |
| BOM (C_BOM) | $11,400 | $11,900 | +$500 |
| Manufactured cost (C_mfg) | $15,400 | $16,075 | +$675 (incl. overhead) |
| Service (s=1.5) | $23,100 | $24,113 | +$1,013 |
| Lifetime TCO | $67,500 | $69,188 | +$1,688 |
| A_robot (N=5, U=0.7) | $19,300 | $19,782 | +$482/yr |

Table J1. Propagation of a 20% compute-subsystem price shock. The $500 direct BOM increase becomes a ~$1,688 lifetime-TCO increase once overhead and the service multiplier are applied — a >3x leverage on the direct shock.

The leverage effect, here roughly 3x, is the quantitative basis for the Section 3.5 argument that second-sourcing and design-for-serviceability in concentrated subsystems (compute, LiDAR, precision actuation) protect deployment economics more than nominal BOM reduction. It also implies that periods of compute or sensor scarcity raise the effective break-even wage, temporarily shrinking the set of regions where automation is favorable — a dynamic worth monitoring given the volatility of those markets.

## Appendix K. Discounted cash-flow and NPV treatment

The body uses simple (undiscounted) annualized cost for transparency. For capital-budgeting rigor, the same model admits a discounted formulation. Let the one-time outlay be C_0 = C_mfg + C_deploy, the annual net saving be S = m*L_loaded - A_service_annual - C_op_annual, the discount rate be r, and the life be N years. The net present value of deploying the robot rather than retaining labor is:

> **NPV = -C_0 + sum_{t=1..N} S / (1 + r)^t + V_eol/(1+r)^N (K1)**

Deployment is value-creating when NPV > 0. The discounted payback period is the smallest T such that the cumulative discounted savings recover C_0. Table K1 evaluates NPV for a mid-wage region (loaded labor $23k, m=1) at three discount rates, holding central robot assumptions; negative NPV at single-shift confirms the body's finding that mid-wage single-shift deployment is marginal, while the m=2 row turns clearly positive.

| Configuration | r = 6% | r = 10% | r = 14% | Decision (at r=10%) |
| --- | --- | --- | --- | --- |
| Mid-wage, m=1 | -$2,100 | -$5,400 | -$8,000 | Reject (NPV<0) |
| Mid-wage, m=2 | +$47,000 | +$39,500 | +$33,400 | Accept (NPV>0) |
| High-wage, m=1 | +$210,000 | +$188,000 | +$169,000 | Accept (strong) |

Table K1. NPV of deployment vs labor (Eq. K1), illustrative. Discounting does not change the qualitative regional/shift conclusions but quantifies the margin and is the form a capital-budgeting committee would use.

Two points follow. First, because the dominant cash flows are recurring labor savings, higher discount rates penalize deployment modestly but do not reverse the regional gradient. Second, the NPV form makes explicit that the deployment decision is an investment under uncertainty; the sensitivity grids of Appendix G can be read directly as the distribution of NPV outcomes across the plausible parameter range.

## Appendix L. Worked break-evens for the entry and expert cohorts

### L.1 Entry cohort

Consider an entry-cohort worker at $7,000 loaded performing a role that is 70% repetitive. The automatable share is worth ~$4,900/yr of loaded labor. A single-shift machine at $19,300 covering that share gives R ~ 3.9 — deeply unfavorable — and even at three shifts (effective $6,430 break-even) the machine only approaches parity with the full role, not the automatable share alone. The rational outcome is to retain the entry worker and, where volume justifies, add machines for the highest-duty fraction while the worker moves to monitoring and exception handling. The entry cohort is the clearest case where automation augments rather than displaces, because the machine's fixed cost dwarfs low entry wages.

### L.2 Expert cohort

An expert-cohort engineer at $120,000 loaded performs architecture, autonomy R&D, and safety-case work — tasks with essentially zero overlap with machine capability. The cost ratio (machine/expert ~ 0.16) is irrelevant because the tasks are non-substitutable: the machine cannot produce a safety case or design a novel deployment. Indeed, each additional fielded machine increases demand for expert time to specify, validate, and govern it. The break-even concept does not apply; the relationship is strictly complementary, and greater automation raises, not lowers, the economic value of the expert cohort.

| Cohort | Loaded | Automatable share | R on share (m=1) | Rational outcome |
| --- | --- | --- | --- | --- |
| Entry | $7,000 | 70% (~$4,900) | ~3.9 | Hire; augment at high volume |
| Mid | $40,000 | 50% (~$20,000) | ~0.97 | Augment; displace routine at m>=2 |
| Expert | $120,000 | ~0% (non-overlap) | n/a | Complement; demand rises |

Table L1. Cohort break-even summary. Only the mid cohort sits near the favorability threshold; entry is protected by low wages, expert by non-substitutability.

## Appendix M. Comparison with alternative deployment modes

A deployed autonomous robot is one of several ways to address a task. The framework extends naturally to alternatives, each with a different cost structure on the same Eqs. 1-10. Table M1 sketches the comparison; the choice among modes is itself part of the deployment decision.

| Mode | Cost character | Best when | Main risk |
| --- | --- | --- | --- |
| Autonomous mobile/service robot | High deploy + service multiple; flexible | Variable layout, multi-task, multi-shift | Integration & service talent cost |
| Collaborative robot (cobot) | Lower deploy; works beside humans | Mixed human-machine cells, mid volume | Throughput ceiling vs full automation |
| Fixed/hard automation | High capex, very low per-unit | Stable high-volume single task | Inflexible to product change |
| Outsourcing / offshoring labor | Pure loaded-labor in another region | Labor-cost arbitrage feasible | Logistics, quality, lead-time |
| Status quo (in-region labor) | L_loaded only | Low wages, low duty, variable tasks | Scarcity, hazard, quality variance |

Table M1. Deployment modes compared. The autonomous-robot vs in-region-labor comparison is the body's focus; cobots and fixed automation are intermediate points on the flexibility-vs-unit-cost frontier.

The mode comparison reinforces the augmentation theme: cobots, which explicitly pair machine and human in one cell, are often the economically and operationally dominant choice in mid-wage, mixed-task settings precisely because they automate the repetitive share while keeping the human on judgment tasks — the configuration the cohort analysis identifies as optimal in most cells of Table 10.

## Appendix N. Uncertainty analysis

The deterministic sweeps of Section 9 can be summarized probabilistically. Treating the key parameters as independent uniform distributions over their tested ranges (utilization 0.4-0.95, service multiplier 1-2, life 5-12, deployment $10-50k) and propagating to A_robot yields an approximate distribution whose central tendency and spread are summarized in Table N1. A formal Monte Carlo simulation (not run here) would refine these, but the bounding sweep already shows that utilization variance dominates the spread of A_robot.

| Statistic | A_robot (US$/productive yr) | Driver |
| --- | --- | --- |
| Low (favorable) decile | ~$9,000 | High U, long N, low s |
| Central estimate | ~$19,300 | Central assumptions |
| High (unfavorable) decile | ~$33,000 | Low U, short N, high s |
| Approx. range (10-90%) | $9k - $33k | ~3.7x spread |

Table N1. Approximate distribution of annualized robot cost across the plausible parameter ranges. The ~3.7x spread is driven primarily by utilization, confirming the tornado ordering of Section 9.4.

The practical reading is that A_robot is not a point but a distribution roughly $9k-$33k wide, and that the operator's job is to push their realization toward the favorable tail through high utilization, multi-shift duty, long serviceable life, and a low service multiplier. The wage denominator then determines whether even the favorable tail clears R = 1 in a given region.

## Appendix O. Source-by-source data caveats

Because the regional and macro figures carry the load of the empirical claims, Table O1 records the principal caveat attached to each major source class, supporting the directional reading urged throughout.

| Source class | Used for | Principal caveat |
| --- | --- | --- |
| OECD / BLS / Destatis | High-wage loaded labor | Definitions of compensation vary; 2024-25 vintages |
| ILO Global Wage Report | Regional wage trends | Real-wage growth aggregates; not site-level |
| World Bank Open Data | Labor force, population, GDP/cap | Modeled estimates; lag and revision |
| Industry TCO analyses | Robot multiples, maintenance % | Practitioner sources; class-dependent |
| IFR World Robotics 2025 | Operational stock, installs | Industrial robots only; excludes service/mobile |
| Human-capital depreciation papers | delta_h ~7% | Wide empirical range (under 1% to double digits) |
| User-provided anchors | BOM, rupee figures, Ati datapoint | Illustrative; not independently verified |

Table O1. Source-by-source caveats. Load-bearing conclusions rest on the directional structure these sources jointly support, not on any single point estimate.

In aggregate, the sources support the paper's qualitative claims robustly — an order-of-magnitude wage dispersion against a roughly fixed robot cost, dominated by utilization and shift coverage — while individual point estimates should be treated as illustrative and replaced with verified local data before any operational decision. This is the appropriate epistemic stance for a deployment framework intended to be re-run with site-specific inputs rather than read as a source of universal thresholds.

## Appendix P. Sectoral analysis

The deployment decision varies not only by region and cohort but by sector, because sectors differ in duty cycle, task structure, labor intensity, and the value of quality and safety. This appendix applies the framework to four representative sectors, holding the central robot assumptions and varying the realistic utilization, shift pattern, and non-cost value.

### P.1 Manufacturing

Manufacturing is the canonical favorable case in high-wage regions: high-duty, multi-shift lines with repetitive, well-structured tasks push utilization toward the top of the range and allow m > 1, so even the five-year life yields rapid payback. Quality and throughput consistency add substantial non-cost value. In low-wage manufacturing the picture inverts under single-shift operation, but export-oriented plants running multiple shifts can still reach favorability, which is consistent with the concentration of global robot stock in manufacturing and in a small number of high-volume economies.

### P.2 Logistics and warehousing

Logistics combines high duty with highly repetitive transport and picking tasks, favorable to mobile robots, but also with large variable demand peaks. Utilization is high during peaks and low in troughs, so the effective annualized cost depends heavily on demand smoothing; operators that can run assets around the clock during peak seasons capture the multi-shift advantage. Labor scarcity and turnover in warehousing also raise the effective loaded labor cost (through recruiting and training churn captured in C_train), tilting the decision toward augmentation even at moderate wages.

### P.3 Agriculture

Agriculture features seasonal, weather-dependent duty cycles that depress average utilization and therefore raise annualized robot cost per productive hour. Tasks are often unstructured (variable terrain, biological variability), increasing deployment and service cost and lowering machine productivity relative to flexible human labor. The framework predicts automation is favorable mainly for the narrow, high-duty, structured sub-tasks (e.g., controlled-environment operations) and remains uneconomical for low-utilization seasonal field tasks in low-wage regions, again an augmentation rather than displacement outcome.

### P.4 Services and care

Service and care work is dominated by non-routine, interpersonal, and judgment tasks with low automatable shares, so the cohort logic assigns most of the role to humans regardless of wage. Where structured sub-tasks exist (cleaning, transport, monitoring), service robots can cover them, freeing human time for the interpersonal core. The non-cost value here often runs the other way: human presence is part of the service, so even a favorable R may not justify substitution. This sector most clearly illustrates that a cost ratio is not a sufficient basis for a deployment decision.

| Sector | Typical utilization / shifts | Automatable share | Dominant outcome |
| --- | --- | --- | --- |
| Manufacturing | High / multi-shift | High | Displace routine (high-wage); augment (low-wage) |
| Logistics | High but peaky / multi-shift | High | Augment; displace at sustained peaks |
| Agriculture | Low / seasonal | Medium (structured only) | Augment narrow tasks; mostly hire |
| Services / care | Variable / single-shift | Low | Complement; human-centric |

Table P1. Sectoral application of the framework. Duty cycle and automatable share, more than wage alone, determine the dominant outcome within each sector.

## Appendix Q. Regional estimation methodology

This appendix documents how the regional loaded-labor estimates in Section 6 and Appendix E were constructed, so that they can be audited and replaced. The procedure has four steps. First, a representative gross wage band for a comparable manufacturing or service-support role was taken from the cited statistical sources (3, 6, 7, 8, 9, 10), preferring the most recent 2024-25 vintage and, where multiple sources disagreed, spanning them as a range rather than selecting a point. Second, a region-appropriate benefit load b within 0.25-0.45 was applied, reflecting documented social-contribution rates; we deliberately used conservative mid-band loads to avoid overstating loaded labor in low-wage regions. Third, a uniform training/overhead allowance scaled to wage was added to capture recruiting, onboarding, supervision, and facility cost; using a uniform rule rather than region-specific overhead keeps the cross-region comparison transparent at the cost of some local precision. Fourth, the resulting band was rounded to two significant figures to signal its order-of-magnitude character.

Three deliberate simplifications follow from this procedure and should be kept in mind. The estimates describe a formal-sector, full-time-equivalent role; they overstate the cost of informal labor, which is widespread in several of the lower-wage regions and which would push R even higher there. The estimates do not adjust for purchasing-power parity, because the robot is priced in internationally traded inputs and the relevant comparison is in nominal deployment cost. And the estimates hold the robot cost fixed across regions, which is appropriate for hardware and service inputs that trade internationally but understates local integration-labor cost differences captured separately through C_deploy. A reviewer reproducing the analysis should substitute national-accounts compensation data, local integration-labor rates, and sector-specific overhead, after which every R and payback figure can be recomputed directly from the equations in Appendix B.

The estimation procedure is intentionally conservative in the direction that matters for the paper's central claim: by using mid-band benefit loads and formal-sector wages, it tends to raise loaded labor in low-wage regions, making the robot look relatively more favorable there than a fuller treatment of informality would. That the framework still finds single-shift automation uneconomical across India and much of Africa under these conservative labor figures strengthens, rather than weakens, the regional-gradient conclusion.

## Appendix R. Extended related work

This appendix expands the literature review of Section 2 with a fuller narrative of the four research streams the paper integrates and the specific way each is used. The intent is to position the contribution precisely and to direct readers to the primary sources for each component.

The first stream is the engineering-economics literature on robot and automation total cost of ownership. This work, much of it practitioner-facing, has established the now-standard decomposition of robot cost into acquisition, integration, operation, maintenance, and end-of-life phases, and the empirical regularities that hardware is a minority of lifetime cost and that lifetime TCO is a multiple of purchase price (1, 2, 5). We adopt its phase structure and its capex-multiple framing but depart from it by expressing service as a multiple of manufactured cost so that supply-chain volatility propagates correctly, and by coupling the output to a labor comparator rather than leaving it as a standalone cost figure.

The second stream is labor-cost accounting and the official statistical apparatus for measuring compensation (3, 6, 7, 8, 9, 10). This literature supplies both the definition of loaded labor we adopt and the cross-country data we use, and it carries the methodological caveats catalogued in Appendix O. Our contribution is not to the measurement of labor cost but to its correct juxtaposition against full robot TCO, a juxtaposition that the two literatures rarely perform together.

The third stream is human-capital theory in the Becker-Mincer tradition and its empirical offshoot on skill depreciation (11, 12). We rely on this stream for the conceptual content of human-capital depreciation and for the empirical range of depreciation rates, and we use it to enforce the paper's central distinction: that skill decay is a property of skills, reversible through training and offset by experience, and never a basis for treating a person as a depreciating asset. This stream is also the theoretical foundation for the augmentation conclusion, since it implies that the response to faster skill obsolescence is investment in people.

The fourth stream is the task-based analysis of automation and employment, which reframes automation as the substitution of machines for tasks rather than for whole jobs, and which predicts complementarity as well as substitution. We operationalize this stream in the cohort analysis (Section 7) by splitting roles into automatable and non-automatable shares and by classifying outcomes as displace, augment, or complement. The integration of all four streams into one transparent, regionally and cohort-resolved deployment model, with an explicit ethical guardrail, is what distinguishes this paper from any one of its constituent literatures.

## Appendix S. Extended note on ethics and the capital/skill distinction

Because the subject of this paper invites a category error with serious ethical consequences, this appendix states the safeguards explicitly and at length. The error is to reason by analogy from the machine to the worker: having modeled the robot as a capital asset with depreciation, salvage value, and a refurbish-or-retire rule, one might be tempted to apply the same apparatus to labor, treating a worker as an asset whose value declines toward a salvage point at which retirement or scrappage becomes rational. Every element of that analogy is rejected here, both because it is economically unfounded and because it is ethically inadmissible.

It is economically unfounded because human-capital theory does not describe people as depreciating assets. It describes skills as a stock that can lose market value when not maintained, but that is simultaneously built by experience and restored by training; the net trajectory of a worker's human capital is frequently rising, not falling, especially early in a career and whenever reskilling occurs. There is no salvage value of a person in the theory, no terminal book value, and no decision rule that compares a person's residual worth to a replacement. The only quantity our model takes from this literature is a training-refresh rate that modestly affects the cost of keeping skills current.

It is ethically inadmissible because people are not capital. A cost ratio that finds a machine cheaper than labor on some task is a statement about the prices of two inputs in a market at a moment in time; it is not a judgment about the value, dignity, or productivity of any person, and it confers no license to displace anyone. Where deployment does affect employment, the obligations that arise — fair notice, transition support, retraining, redeployment, and respect for the affected workers' agency — are moral and often legal requirements that sit entirely outside the cost model and that the model is not competent to adjudicate. The decision framework in Section 8 therefore makes human-impact considerations a binding constraint applied after, and never overridden by, the cost computation.

Finally, the direction of the paper's own findings should be noted. The framework concludes that the dominant economically rational outcome is augmentation, not displacement; that expert human cohorts become more valuable as automation spreads; and that faster skill obsolescence is an argument for greater investment in people. These conclusions are not added as a disclaimer but emerge from the analysis itself, and they are the reason the strict separation of capital depreciation from human-capital skill decay is not merely a matter of careful wording but a load-bearing element of the model's logic.

## Appendix T. Summary of key quantitative findings

For convenience, Table T1 collects the principal quantitative results of the paper in one place, with the section in which each is derived. All figures are illustrative under the stated central assumptions and should be recomputed with site-specific inputs.

| Finding | Value | Section |
| --- | --- | --- |
| Manufactured cost C_mfg | ~$15,400 | 3.4 / 3.6 |
| Lifetime TCO (central) | ~$67,500 | 3.6 |
| Annualized robot cost (N=5) | ~$19,300/productive yr | 3.6 |
| Annualized robot cost (N=8) | ~$12,100/productive yr | 3.6 |
| Single-shift break-even loaded labor | ~$19,300/yr | 6.3 |
| Two-shift break-even loaded labor | ~$9,650/yr | 6.3 |
| R, United States | 0.20-0.26 (favorable) | 6 |
| R, India (single-shift) | 1.8-3.9 (unfavorable) | 6 |
| Dominant sensitivity lever | Utilization (then shifts) | 9 |
| BOM shock leverage into TCO | ~3x direct share | Appendix J |
| A_robot 10-90% range | $9k - $33k | Appendix N |
| Robot penetration | ~0.57 per 1,000 people | 10 |
| Dominant cohort outcome | Augmentation | 7 |

Table T1. Consolidated quantitative findings. Figures are illustrative under central assumptions.

The single most important takeaway from the consolidated results is the contrast between a robot annualized cost that is roughly fixed near $19,300/productive year and a regional loaded labor cost that ranges from about $5,000 to $95,000. This one-to-twenty span on the labor side, against near-invariance on the robot side, is the structural reason the deployment decision is regional, the reason utilization and shift coverage are the operative levers, and the reason the dominant rational outcome is augmentation rather than wholesale displacement.

## Appendix U. Anticipated reviewer questions and responses

To assist review, this appendix anticipates the most likely methodological questions and states our responses concisely.

- Why model service as a multiple of manufactured cost rather than a fixed annual fee? Because empirical maintenance scales with system complexity and value, and because a multiplicative form lets BOM and supply-chain volatility propagate into lifetime cost correctly (Section 2.1, Appendix J). The multiplier is sensitized over 1x-2x.
- Are the regional labor figures robust enough to support the conclusions? The conclusions are qualitative and directional — an order-of-magnitude wage dispersion against a roughly fixed robot cost — and hold across the full plausible range of the cited sources. The estimation is deliberately conservative toward making the robot look favorable in low-wage regions (Appendix Q), so the regional gradient is if anything understated.
- Does the five-year robot life bias the results? It raises annualized cost and tightens favorability relative to longer lives; we report both N=5 and N=8 and sensitize N to 12 (Section 9). The qualitative gradient is invariant to N.
- Why simple ratios rather than full NPV? For transparency in the body; Appendix K provides the discounted NPV formulation and shows discounting does not change the regional or shift conclusions.
- Is the human-capital depreciation treatment ethically and economically sound? Yes: it follows Becker-Mincer in treating depreciation as skill decay, never as depreciation of a person; it enters only as a training-refresh cost and never triggers any retirement rule (Sections 5, Appendix S).
- How were vendor names and the BOM chosen? Vendors are illustrative, representative examples, not endorsements or price quotes; the BOM and rupee anchors are user-provided illustrative figures, flagged throughout and excluded from verified claims (Appendices C, O).
- What would most strengthen the work? Empirical calibration of the service multiplier and cohort productivity indices from fleet telemetry and task-level studies, and a dynamic extension allowing wages, prices, and penetration to evolve (Section 11.6).
We submit that the framework's principal value is not any single number but its transparency: every result is a deterministic function of explicitly stated, separately sourced parameters, so a reviewer or operator can substitute their own inputs and re-derive the entire analysis, including the strict and load-bearing separation between capital depreciation and human-capital skill decay.
