# Synth911Gen -- Consolidated & Enhanced Recommendations (Final)

## Overview

This document merges prior recommendations with additional senior review
input. It focuses on **realistic temporal modeling, CAD fidelity, and
operational simulation behavior**.

------------------------------------------------------------------------

# 1. Calibrated Time Distributions (Empirical)

## Queue Time

``` python
def generate_queue_times(n):
    return np.clip(np.random.lognormal(3.7, 0.9, n).astype(int), 0, 3600)
```

## Dispatch Time (Priority-Based)

``` python
DISPATCH_PARAMS = {
    1: (1.5, 0.7, 60),
    2: (2.5, 1.0, 600),
    3: (1.5, 0.7, 60),
    4: (5.5, 1.2, 3600),
    5: (5.0, 1.3, 7200),
}
```

## Phone Time

``` python
def generate_phone_times(n):
    short = np.random.exponential(60, int(n*0.35))
    long = np.random.gamma(2.5, 90, n-int(n*0.35))
    x = np.concatenate([short,long]).astype(int)
    np.random.shuffle(x)
    return np.clip(x,0,3600)
```

## Ack Time

``` python
def generate_ack_times(n):
    return np.clip(np.random.gamma(1.2,12,n).astype(int),0,600)
```

## Enroute Time

``` python
def generate_enroute_times(n):
    return np.clip(np.random.gamma(2.5,120,n).astype(int),0,3600)
```

------------------------------------------------------------------------

# 2. Parallel Dispatch Model (CRITICAL UPDATE)

``` python
DISPATCH_INIT_FRACTION = {
    1:(0.05,0.2),
    5:(0.9,1.2)
}
```

``` python
dispatch_ready = event_time + timedelta(seconds=phone_time*fraction)
time_call_dispatched = dispatch_ready + queue_time + dispatch_time
```

✔ Dispatch CAN occur before disconnect

------------------------------------------------------------------------

# 3. Diurnal Call Volume

``` python
HOURLY_WEIGHTS = [...]
hours = np.random.choice(np.arange(24), p=HOURLY_WEIGHTS, size=n)
```

------------------------------------------------------------------------

# 4. Unit Availability (Queueing Constraint)

``` python
if active_units >= capacity:
    queue_time += 60
```

------------------------------------------------------------------------

# 5. On-Scene Time (Fix Clipping)

``` python
def generate_on_scene_times(n):
    fast = np.random.exponential(90,int(n*0.15))
    std = np.random.gamma(2.5,900,n-int(n*0.15))
    x = np.concatenate([fast,std]).astype(int)
    np.random.shuffle(x)
    return np.clip(x,0,86400)
```

------------------------------------------------------------------------

# 6. Reception Vocabulary (Real CAD)

``` python
RECEPTION_METHODS = ["E-911","Phone","OFFICER","Radio","C2C","NOT CAPTURED","Text","CAD2CAD"]
RECEPTION_WEIGHTS = [0.33,0.38,0.14,0.06,0.05,0.02,0.01,0.01]
```

------------------------------------------------------------------------

# 7. Disposition Codes

``` python
("NR","NR-No Report"), ("RE","RE-Report"), ("CI","CI-Citation")
```

Use agency-weighted distributions.

------------------------------------------------------------------------

# 8. Personnel Modeling

-   Separate dispatcher & call-taker pools
-   Zipf workload imbalance

``` python
weights = [1/(i+1) for i in range(n)]
```

------------------------------------------------------------------------

# 9. Incident Start Time

``` python
incident_start_time = event_time - random(0–30 sec)
```

------------------------------------------------------------------------

# 10. Priority-Weighted Problem Selection

``` python
PRIORITY_WEIGHTS = {"POLICE":[0.19,0.24,0.21,0.20,0.16]}
```

------------------------------------------------------------------------

# 11. Agency Naming

Replace LAW → POLICE or configurable mapping.

------------------------------------------------------------------------

# 12. Geographic Modeling

``` python
DISTRICTS = {"URBAN":300,"SUBURBAN":600,"RURAL":1200}
```

------------------------------------------------------------------------

# 13. Config-Driven Design

``` python
import yaml
config = yaml.safe_load(open("config.yaml"))
```

------------------------------------------------------------------------

# 14. Performance Improvements

-   Replace Polars map_elements
-   Vectorize with numpy

------------------------------------------------------------------------

# 15. Optional: Discrete Event Simulation

Use simpy for full realism.

------------------------------------------------------------------------

# Libraries

-   numpy
-   scipy (optional)
-   simpy (optional)
-   pyyaml
-   InquirerPy

------------------------------------------------------------------------

# Final Recommendation

Transition from: ❌ Independent sampling\
→ ✅ Constraint-driven simulation + empirical calibration

This produces training-grade CAD data.
