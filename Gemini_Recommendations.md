# Recommendations to Improve Realism of Synthetic 9-1-1 CAD Data  

**File Reviewed:** `synth911gen.py`  
**Purpose:** Improve temporal realism and operational authenticity of synthetic CAD data used for analyst training and product development.

---

## Executive Summary

The current generator provides a strong structural foundation (agency distributions, priority mapping, shift logic, timestamp chaining). However, the **elapsed time modeling is statistically independent and operationally unrealistic** in several important ways:

1. Time intervals are not dependent on **priority**, **agency**, or **call volume**.
2. Phone, queue, dispatch, acknowledgment, and enroute times are modeled independently.
3. There is no modeling of **call stacking**, **unit availability**, or **peak-hour congestion**.
4. Event timestamps can create unrealistic operational sequences.
5. Personnel modeling lacks staffing constraints.
6. Disposition logic does not reflect real-world outcomes.

For analyst training and product validation, time realism is the single most important improvement area.

Below are prioritized recommendations.

---

# 1. Make All Time Durations Conditional on Priority and Agency

## Current Problem

Time fields are generated from global distributions:

- `queue_time` → lognormal
- `dispatch_time` → chi-square
- `phone_time` → exponential/gamma mix
- `ack_time`, `enroute_time`, `on_scene_time` → gamma

These are independent of:

- `priority_number`
- `agency`
- time of day
- system load

In real 9-1-1 centers:

- Priority 1 calls are answered immediately.
- Priority 5 calls may queue.
- EMS response times differ from LAW.
- Fire apparatus has longer turnout times.
- Night shifts have different processing behavior.

---

## Recommendation

Create **priority- and agency-based parameter profiles**.

### Example: Configuration-Based Time Profiles

```python
TIME_PROFILES = {
    "LAW": {
        1: {"queue_mean": 3, "dispatch_mean": 20, "enroute_mean": 300},
        2: {"queue_mean": 10, "dispatch_mean": 45, "enroute_mean": 420},
        3: {"queue_mean": 20, "dispatch_mean": 90, "enroute_mean": 600},
        4: {"queue_mean": 40, "dispatch_mean": 180, "enroute_mean": 900},
        5: {"queue_mean": 120, "dispatch_mean": 300, "enroute_mean": 1200},
    },
    "EMS": {
        1: {"queue_mean": 2, "dispatch_mean": 15, "enroute_mean": 240},
        2: {"queue_mean": 5, "dispatch_mean": 30, "enroute_mean": 360},
        3: {"queue_mean": 15, "dispatch_mean": 60, "enroute_mean": 600},
        4: {"queue_mean": 30, "dispatch_mean": 120, "enroute_mean": 900},
        5: {"queue_mean": 60, "dispatch_mean": 240, "enroute_mean": 1500},
    }
}
