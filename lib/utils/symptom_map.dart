const Map<String, List<String>> symptomMap = {
  // ==========================================================
  // MODEL 1 : STETHOSCOPIC CONDITIONS
  // ==========================================================

  "copd": [
    "Chronic cough",
    "Shortness of breath",
    "Excess mucus or phlegm",
    "Wheezing",
    "Chest tightness",
    "Fatigue",
  ],

  "asthma": [
    "Wheezing",
    "Shortness of breath",
    "Chest tightness",
    "Cough",
    "Night cough",
  ],

  "pneumonia": [
    "Cough with mucus",
    "Fever",
    "Chills",
    "Shortness of breath",
    "Chest pain or discomfort",
    "Fatigue",
  ],

  "bronchial": [
    "Persistent cough",
    "Mucus production",
    "Chest discomfort",
    "Wheezing",
    "Breathing difficulty",
    "Airway irritation",
  ],

  "healthy": [
    "No abnormal respiratory patterns detected",
  ],

  // ==========================================================
  // MODEL 2 : NORMAL AUDIO CONDITIONS
  // ==========================================================

  "covid19": [
    "Dry cough",
    "Fatigue",
    "Fever",
    "Sore throat",
    "Shortness of breath",
    "Body aches",
  ],

  "healthy_cough": [
    "No significant abnormal respiratory patterns detected",
  ],

  "sneezing": [
    "Sneezing episodes",
    "Nasal irritation",
    "Runny nose",
    "Allergy-related symptoms",
  ],
};

const Map<String, String> conditionLabelMap = {
  // ==========================================================
  // MODEL 1 LABELS
  // ==========================================================

  "copd": "COPD",
  "asthma": "Asthma",
  "pneumonia": "Pneumonia",
  "healthy": "Healthy",
  "bronchial": "Bronchial",

  // ==========================================================
  // MODEL 2 LABELS
  // ==========================================================

  "covid19": "COVID-19",
  "healthy_cough": "Healthy Cough",
  "sneezing": "Sneezing",
};

String formatCondition(String raw) {
  return conditionLabelMap[raw] ?? raw;
}