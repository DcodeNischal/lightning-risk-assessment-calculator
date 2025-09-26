const Map<String, double> locationFactorCD = {
  'Isolated Structure (Within a distance of 3H)': 1.0,
  'Structure surrounded by objects of same height or smaller': 0.5,
  'Structure surrounded by higher objects': 0.25,
  'Isolated Structure on a hill top': 2.0,
};

const Map<String, double> factorPB = {
  'Structure is not Protected by an LPS': 1.0,
  'Protected by an LPS Class I': 0.02,
  'Protected by an LPS Class II': 0.06,
  'Protected by an LPS Class III': 0.10,
  'Protected by an LPS Class IV': 0.16,
};

const Map<String, double> factorCI = {
  'Overhead Line': 1.0,
  'Buried': 0.5,
};

const Map<String, double> factorCE = {
  'Urban': 0.5,
  'Suburban': 1.0,
  'Rural': 2.0,
};

const Map<String, double> factorCT = {
  'Low-Voltage Power': 1.0,
  'High-Voltage Power': 0.75,
  'TLC or data line': 0.5,
};
