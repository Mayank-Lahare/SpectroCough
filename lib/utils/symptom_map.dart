const Map<String, List<String>> symptomMap = {
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

  "healthy": ["No abnormal respiratory patterns detected"],
};

const Map<String, String> conditionLabelMap = {
  "copd": "COPD",
  "asthma": "Asthma",
  "pneumonia": "Pneumonia",
  "healthy": "Healthy",
  "bronchial": "Bronchial",
};

String formatCondition(String raw) {
  return conditionLabelMap[raw] ?? raw;
}
