const List<String> listStrParticle = [
  '6X',
  '10X',
  '15X',
  '6E',
  '9E',
  '12E',
  '16E'
];

const Map<String, List<double>> mapDefaultDepth = {
  '6X': [
    1,
    1.5,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
    19,
    20,
    30
  ],
  '10X': [
    1,
    2,
    2.5,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
    19,
    20,
    30
  ],
  '15X': [
    0.0,
    1.0,
    1.5,
    2.0,
    3.0,
    4.0,
    5.0,
    6.0,
    7.0,
    8.0,
    9.0,
    10.0,
    11.0,
    12.0,
    13.0,
    14.0,
    15.0,
    16.0,
    17.0,
    18.0,
    19.0,
    20.0,
    21.0,
    22.0,
    23.0,
    24.0,
    25.0,
    26.0,
    27.0,
    28.0
  ],
  '6E': [
    0.0,
    5.0,
    10.0,
    12.5,
    15.0,
    17.0,
    19.0,
    20.5,
    21.7,
    22.8,
    24.0,
    25.2,
    25.9,
    26.6,
    27.4,
    28.4,
    29.9,
    32.0
  ],
  '9E': [
    0.0,
    5.3,
    11.7,
    19.5,
    23.4,
    24.8,
    26.7,
    29.3,
    31.5,
    33.3,
    34.8,
    36.1,
    37.3,
    38.5,
    39.4,
    40.5,
    42.0,
    44.8
  ],
  '12E': [
    0.0,
    5.6,
    13.8,
    25.0,
    32.5,
    35.0,
    37.9,
    40.0,
    41.8,
    44.9,
    47.3,
    49.6,
    51.7,
    54.0,
    56.4,
    57.8,
    59.8,
    62.7,
    67.5
  ],
  '16E': [
    0.0,
    5.6,
    18.5,
    31.0,
    46.2,
    50.3,
    53.4,
    55.9,
    59.7,
    63.1,
    66.1,
    68.8,
    71.9,
    75.3,
    77.4,
    80.0,
    84.2,
    90.0
  ],
};

Map<String, Map<int, List<double>>> mapDefaultPdd = {
  '6X': {
    0: [
      98.5,
      100.0,
      97.9,
      93.9,
      90.0,
      86.3,
      82.0,
      77.5,
      73.2,
      69.2,
      65.4,
      61.8,
      58.4,
      55.2,
      52.1,
      49.3,
      46.5,
      44.0,
      41.5,
      39.2,
      37.1,
      21.0
    ],
    5: [
      98.5,
      100.0,
      98.0,
      94.0,
      90.2,
      86.6,
      82.4,
      77.9,
      73.7,
      69.8,
      66.0,
      62.4,
      59.0,
      55.9,
      52.8,
      50.0,
      47.3,
      44.7,
      42.3,
      40.0,
      37.8,
      21.6
    ],
    7: [
      98.7,
      100.0,
      98.0,
      94.2,
      90.5,
      87.0,
      83.0,
      78.7,
      74.6,
      70.6,
      66.9,
      63.4,
      60.1,
      56.9,
      54.0,
      51.1,
      48.4,
      45.9,
      43.5,
      41.2,
      39.0,
      22.7
    ],
    10: [
      99.0,
      100.0,
      98.1,
      94.4,
      90.8,
      87.3,
      83.5,
      79.2,
      75.2,
      71.3,
      67.7,
      64.2,
      60.9,
      57.8,
      54.8,
      52.0,
      49.4,
      46.8,
      44.4,
      42.1,
      40.0,
      23.5
    ],
    12: [
      99.2,
      100.0,
      98.1,
      94.5,
      91.0,
      87.6,
      83.9,
      79.7,
      75.7,
      71.9,
      68.3,
      64.9,
      61.5,
      58.5,
      55.6,
      52.8,
      50.1,
      47.6,
      45.2,
      42.9,
      40.8,
      24.2
    ],
    15: [
      99.4,
      100.0,
      98.2,
      94.7,
      91.2,
      88.0,
      84.5,
      80.3,
      76.4,
      72.7,
      69.1,
      65.7,
      62.5,
      59.4,
      56.5,
      53.7,
      51.1,
      48.6,
      46.2,
      43.9,
      41.8,
      25.1
    ],
    20: [
      99.5,
      100.0,
      98.3,
      94.9,
      91.6,
      88.4,
      85.1,
      81.1,
      77.3,
      73.6,
      70.1,
      66.8,
      63.6,
      60.6,
      57.7,
      55.0,
      52.4,
      49.9,
      47.5,
      45.2,
      43.1,
      26.4
    ],
    30: [
      99.5,
      100.0,
      98.3,
      95.0,
      91.8,
      88.7,
      85.6,
      81.7,
      77.9,
      74.3,
      70.9,
      67.6,
      64.5,
      61.5,
      58.7,
      56.0,
      53.4,
      50.9,
      48.6,
      46.3,
      44.2,
      27.4
    ],
    40: [
      99.5,
      100.0,
      98.4,
      95.1,
      92.0,
      89.0,
      86.7,
      82.2,
      78.5,
      75.0,
      71.6,
      68.3,
      65.3,
      62.3,
      59.5,
      56.8,
      54.2,
      51.8,
      49.4,
      47.2,
      45.0,
      28.3
    ]
  },
  '10X': {
    0: [
      83.4,
      98.5,
      100.0,
      99.5,
      96.5,
      92.4,
      88.0,
      83.6,
      79.7,
      76.1,
      72.8,
      69.0,
      65.6,
      62.7,
      60.0,
      56.9,
      54.4,
      51.6,
      49.2,
      47.0,
      44.6,
      27.5
    ],
    5: [
      84.5,
      98.8,
      100.0,
      99.5,
      96.4,
      92.4,
      88.4,
      84.0,
      80.7,
      77.0,
      74.0,
      70.3,
      67.1,
      63.8,
      61.4,
      58.6,
      55.9,
      53.3,
      50.7,
      48.2,
      46.4,
      29.2
    ],
    7: [
      85.4,
      99.2,
      100.0,
      99.7,
      96.5,
      92.7,
      88.9,
      84.8,
      81.8,
      78.0,
      75.3,
      71.4,
      68.8,
      65.3,
      62.9,
      59.6,
      57.3,
      54.9,
      52.5,
      50.3,
      48.2,
      30.8
    ],
    10: [
      87.8,
      99.2,
      100.0,
      99.4,
      96.4,
      92.5,
      89.1,
      85.5,
      82.2,
      78.7,
      75.9,
      72.3,
      69.8,
      66.4,
      64.2,
      61.4,
      58.8,
      56.1,
      54.2,
      51.6,
      49.7,
      32.3
    ],
    12: [
      89.0,
      99.5,
      100.0,
      99.1,
      96.1,
      92.3,
      89.0,
      86.0,
      82.4,
      78.9,
      76.0,
      72.8,
      70.2,
      67.1,
      65.0,
      61.9,
      59.8,
      57.0,
      55.4,
      52.6,
      50.6,
      33.2
    ],
    15: [
      91.8,
      99.8,
      100.0,
      98.9,
      95.7,
      92.3,
      89.0,
      86.0,
      82.7,
      79.2,
      76.4,
      73.2,
      70.7,
      67.6,
      65.4,
      62.5,
      60.3,
      58.0,
      55.7,
      53.0,
      51.3,
      34.0
    ],
    20: [
      92.5,
      99.8,
      100.0,
      98.8,
      95.7,
      92.3,
      89.0,
      86.2,
      82.7,
      80.0,
      76.7,
      73.8,
      70.8,
      68.0,
      65.6,
      62.7,
      60.5,
      58.0,
      55.8,
      53.5,
      51.6,
      34.3
    ],
    30: [
      93.4,
      99.9,
      100.0,
      98.6,
      95.6,
      92.3,
      89.0,
      86.4,
      82.7,
      80.0,
      77.0,
      74.0,
      71.2,
      68.5,
      65.8,
      63.0,
      60.8,
      58.2,
      56.2,
      54.0,
      52.0,
      34.6
    ],
    40: [
      94.1,
      100.0,
      100.0,
      98.5,
      95.6,
      92.3,
      89.1,
      86.4,
      82.7,
      80.0,
      77.1,
      74.3,
      71.4,
      68.7,
      66.0,
      63.2,
      61.0,
      58.4,
      56.5,
      54.2,
      52.3,
      35.0
    ]
  },
  '15X': {
    10: [
      36.0,
      85.2,
      95.0,
      98.8,
      99.9,
      97.3,
      93.6,
      89.8,
      86.4,
      82.8,
      79.4,
      76.0,
      73.2,
      70.0,
      66.9,
      64.0,
      61.3,
      58.7,
      56.4,
      53.9,
      51.6,
      49.5,
      47.4,
      45.3,
      43.5,
      41.7,
      39.9,
      38.3,
      36.7,
      35.1
    ]
  },
  '6E': {
    10: [
      81.0,
      88.0,
      97.0,
      99.9,
      96.5,
      90.0,
      80.0,
      70.0,
      60.0,
      50.0,
      40.0,
      30.0,
      25.0,
      20.0,
      15.0,
      10.0,
      4.0,
      1.0
    ]
  },
  '9E': {
    10: [
      84.5,
      90.0,
      95.5,
      100.0,
      97.5,
      95.0,
      90.0,
      80.0,
      70.0,
      60.0,
      50.0,
      40.0,
      30.0,
      20.0,
      15.0,
      10.0,
      5.0,
      1.0
    ]
  },
  '12E': {
    10: [
      91.0,
      95.0,
      98.5,
      100.0,
      97.5,
      95.0,
      90.0,
      85.0,
      80.0,
      70.0,
      60.0,
      50.0,
      40.0,
      30.0,
      20.0,
      15.0,
      10.0,
      5.0,
      2.0
    ]
  },
  '16E': {
    10: [
      93.3,
      95.0,
      99.0,
      100.0,
      95.0,
      90.0,
      85.0,
      80.0,
      70.0,
      60.0,
      50.0,
      40.0,
      30.0,
      20.0,
      15.0,
      10.0,
      5.0,
      3.0
    ]
  }
};

Map<String, Map<double, double>> scatterCollimator = {
  '6X': {
    1: 0.222,
    2: 0.801,
    3: 0.931,
    4: 0.958,
    5: 0.968,
    6: 0.976,
    8: 0.990,
    10: 1.000,
    12: 1.008,
    15: 1.016,
    18: 1.024,
    20: 1.034,
    25: 1.067,
    30: 1.087,
    35: 1.104,
    40: 1.109,
  }
};

Map<String, Map<double, double>> scatterPatient = {
  '6X': {
    1: 2.685,
    2: 0.975,
    3: 0.886,
    4: 0.896,
    5: 0.918,
    6: 0.938,
    8: 0.972,
    10: 1.000,
    12: 1.022,
    15: 1.050,
    18: 1.074,
    20: 1.081,
    25: 1.087,
    30: 1.100,
    35: 1.109,
    40: 1.120,
  }
};
