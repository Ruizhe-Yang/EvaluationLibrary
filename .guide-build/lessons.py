from titles import TITLES, FAULT_NAMES
from lesson_mslfaults import DATA as msl
from lesson_anomaly import DATA as anomaly
from lesson_protection import DATA as protection
from lesson_scenario import DATA as scenario
from lesson_uncertainty import DATA as uncertainty
from lesson_evaluation import DATA as evaluation
LESSONS = {
    'MSLFaults': msl,
    'AnomalyLibrary': anomaly,
    'ProtectionLibrary': protection,
    'ScenarioLibrary': scenario,
    'UncertaintyLibrary': uncertainty,
    'EvaluationLibrary': evaluation,
}
from refinements import apply
apply(LESSONS, TITLES)
