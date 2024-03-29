//region First source
const List<double> listPhotonDepthDefault = [
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
];

const Map<String, List<double>> mapDefaultPddFirst = {
  '6X': [
    52.1,
    97.6,
    100.0,
    98.7,
    94.9,
    90.7,
    86.6,
    82.5,
    78.5,
    74.9,
    70.8,
    67.3,
    64.0,
    60.4,
    57.5,
    54.5,
    51.6,
    49.0,
    46.3,
    44.0,
    41.7,
    39.5,
    37.4,
    35.5,
    33.7,
    31.9,
    30.3,
    28.7,
    27.3,
    25.9
  ],
  '10X': [
    40.9,
    91.4,
    98.0,
    99.9,
    98.5,
    94.7,
    90.9,
    87.2,
    83.3,
    79.8,
    76.2,
    72.8,
    69.6,
    66.4,
    63.5,
    60.6,
    57.9,
    55.1,
    52.7,
    50.4,
    48.0,
    45.8,
    43.7,
    41.7,
    39.9,
    38.0,
    36.3,
    34.6,
    33.2,
    31.6
  ],
  '15X': [
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
  ],
  '6E': [
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
  ],
  '9E': [
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
  ],
  '12E': [
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
  ],
  '16E': [
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
};
//endregion First source

//region Stenson tables
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

Map<String, Map<int, List<double>>> mapDefaultPddStenson = {
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
//endregion Stenson tables

//region composite
Map<String, Map<int, List<double>>> mapDefaultPdd = {
  '6X': {
    0: [
      19.2,
      96.8,
      100.0,
      97.4,
      91.1,
      85.3,
      79.9,
      74.8,
      70.1,
      65.7,
      61.5,
      57.7,
      54.0,
      50.7,
      47.5,
      44.6,
      41.8,
      39.2,
      36.8,
      34.5,
      32.4,
      30.4,
      28.6,
      26.8,
      25.2,
      23.6,
      22.2,
      20.9,
      19.6,
      18.4,
      17.3,
      16.2
    ],
    4: [
      19.2,
      96.9,
      100.0,
      98.2,
      93.8,
      89.6,
      84.5,
      79.7,
      75.1,
      70.8,
      66.7,
      62.8,
      59.2,
      55.7,
      52.4,
      49.4,
      46.6,
      43.9,
      41.4,
      39.0,
      36.8,
      34.6,
      32.7,
      30.8,
      29.1,
      27.5,
      26.0,
      24.5,
      23.2,
      21.9,
      20.7,
      19.5
    ],
    7: [
      21.8,
      97.0,
      100.0,
      98.5,
      94.9,
      91.3,
      86.6,
      82.1,
      77.8,
      73.7,
      69.8,
      66.1,
      62.4,
      58.9,
      55.6,
      52.5,
      49.6,
      46.9,
      44.3,
      41.9,
      39.6,
      37.4,
      35.3,
      33.4,
      31.6,
      29.9,
      28.3,
      26.7,
      25.3,
      24.0,
      22.7,
      21.4
    ],
    10: [
      25.6,
      97.1,
      100.0,
      98.6,
      95.1,
      91.5,
      87.1,
      83.0,
      79.0,
      75.1,
      71.4,
      67.8,
      64.2,
      60.9,
      57.7,
      54.6,
      51.7,
      49.1,
      46.4,
      44.0,
      41.7,
      39.5,
      37.4,
      35.4,
      33.6,
      31.8,
      30.1,
      28.5,
      27.0,
      25.6,
      24.2,
      22.9
    ],
    13: [
      29.1,
      97.3,
      100.0,
      98.6,
      95.2,
      91.6,
      87.7,
      83.8,
      79.9,
      76.2,
      72.6,
      69.2,
      65.8,
      62.4,
      59.3,
      56.3,
      53.5,
      50.9,
      48.2,
      45.8,
      43.5,
      41.2,
      39.1,
      37.1,
      35.2,
      33.4,
      31.7,
      30.0,
      28.4,
      26.9,
      25.6,
      24.2
    ],
    16: [
      32.6,
      97.4,
      100.0,
      98.6,
      95.3,
      91.8,
      88.1,
      84.3,
      80.6,
      77.0,
      73.5,
      70.1,
      66.8,
      63.5,
      60.4,
      57.4,
      54.7,
      52.0,
      49.4,
      47.0,
      44.7,
      42.5,
      40.3,
      38.3,
      36.4,
      34.6,
      32.9,
      31.2,
      29.6,
      28.1,
      26.7,
      25.3
    ],
    20: [
      37.5,
      97.6,
      100.0,
      98.7,
      95.5,
      92.2,
      88.6,
      85.0,
      81.4,
      77.9,
      74.5,
      71.2,
      67.9,
      64.8,
      61.7,
      58.8,
      56.1,
      53.4,
      50.9,
      48.5,
      46.1,
      43.9,
      41.8,
      39.8,
      37.9,
      36.0,
      34.3,
      32.6,
      31.0,
      29.5,
      28.1,
      26.7
    ],
    24: [
      40.4,
      97.8,
      100.0,
      98.7,
      95.6,
      92.3,
      88.8,
      85.4,
      82.0,
      78.6,
      75.3,
      72.0,
      68.8,
      65.8,
      62.7,
      59.9,
      57.1,
      54.5,
      52.0,
      49.6,
      47.2,
      45.0,
      42.9,
      40.8,
      38.9,
      37.1,
      35.3,
      33.6,
      32.0,
      30.5,
      29.0,
      27.6
    ],
    30: [
      44.5,
      98.1,
      100.0,
      98.7,
      95.6,
      92.3,
      89.0,
      85.7,
      82.4,
      79.0,
      75.8,
      72.7,
      69.4,
      66.4,
      63.4,
      60.6,
      57.9,
      55.4,
      52.9,
      50.5,
      48.2,
      45.9,
      43.7,
      41.7,
      39.8,
      37.8,
      36.0,
      34.3,
      32.6,
      31.1,
      29.5,
      28.0
    ],
    35: [
      47.6,
      98.3,
      100.0,
      98.7,
      95.5,
      92.2,
      88.9,
      85.7,
      82.3,
      79.0,
      75.7,
      72.6,
      69.3,
      66.2,
      63.3,
      60.4,
      57.6,
      55.1,
      52.6,
      50.2,
      47.9,
      45.6,
      43.5,
      41.5,
      39.5,
      37.6,
      35.8,
      34.1,
      32.4,
      30.9,
      29.4,
      27.9
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
    4: [
      24.6,
      78.4,
      96.5,
      100.0,
      98.7,
      95.0,
      90.5,
      86.7,
      83.0,
      79.3,
      75.3,
      71.7,
      68.6,
      65.2,
      62.3,
      58.9,
      56.3,
      54.0,
      51.7,
      49.2,
      46.9,
      44.4,
      42.2,
      40.3,
      38.7,
      37.4,
      35.7,
      33.9,
      32.6,
      31.1,
      29.7
    ],
    7: [
      28.7,
      78.7,
      96.9,
      100.0,
      98.5,
      95.0,
      91.2,
      87.3,
      83.6,
      80.2,
      76.4,
      72.9,
      70.0,
      66.9,
      63.9,
      61.1,
      58.5,
      56.0,
      53.4,
      51.2,
      48.7,
      46.5,
      44.6,
      42.6,
      40.7,
      39.0,
      37.3,
      35.7,
      34.2,
      32.6,
      31.2
    ],
    10: [
      32.8,
      81.0,
      97.5,
      100.0,
      97.7,
      94.6,
      91.1,
      87.3,
      83.7,
      80.1,
      76.8,
      73.8,
      70.7,
      67.6,
      64.6,
      62.1,
      59.5,
      56.8,
      54.2,
      52.0,
      49.8,
      47.9,
      45.6,
      43.8,
      42.0,
      40.1,
      38.5,
      36.8,
      35.6,
      33.9,
      32.4
    ],
    13: [
      36.2,
      83.6,
      98.6,
      100.0,
      97.6,
      94.4,
      90.7,
      86.7,
      83.0,
      80.0,
      77.1,
      74.2,
      71.1,
      68.4,
      65.5,
      62.6,
      60.2,
      57.7,
      55.4,
      53.0,
      50.8,
      48.7,
      46.7,
      44.9,
      42.7,
      41.1,
      39.4,
      37.8,
      36.3,
      34.5,
      33.4
    ],
    16: [
      39.6,
      85.2,
      99.1,
      100.0,
      97.4,
      94.1,
      90.3,
      87.1,
      83.6,
      80.6,
      77.3,
      74.2,
      71.4,
      68.6,
      66.0,
      63.2,
      60.6,
      58.2,
      55.9,
      53.4,
      51.3,
      49.3,
      47.3,
      45.5,
      43.4,
      41.8,
      40.0,
      38.4,
      37.2,
      35.8,
      34.1
    ],
    20: [
      44.0,
      87.7,
      99.5,
      100.00,
      96.5,
      93.2,
      89.9,
      86.8,
      83.7,
      80.4,
      77.7,
      74.4,
      71.4,
      68.8,
      65.7,
      63.2,
      61.1,
      58.8,
      56.4,
      54.0,
      51.9,
      49.7,
      47.6,
      45.8,
      43.8,
      42.1,
      40.3,
      38.7,
      37.7,
      36.2,
      34.8
    ],
    25: [
      48.8,
      90.1,
      99.7,
      100.0,
      97.2,
      93.3,
      90.4,
      86.9,
      83.5,
      81.0,
      77.7,
      74.8,
      72.0,
      69.4,
      66.6,
      64.0,
      61.5,
      59.2,
      56.9,
      55.0,
      52.9,
      50.7,
      48.6,
      46.7,
      44.8,
      43.3,
      41.8,
      39.9,
      38.4,
      36.2,
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
    4: 0.948,
    5: 0.961,
    6: 0.970,
    7: 0.979,
    8: 0.987,
    9: 0.994,
    10: 1.000,
    11: 1.004,
    12: 1.008,
    13: 1.013,
    14: 1.017,
    15: 1.021,
    16: 1.024,
    17: 1.028,
    18: 1.031,
    19: 1.035,
    20: 1.038,
    22: 1.041,
    24: 1.045,
    26: 1.048,
    28: 1.051,
    30: 1.052,
    32: 1.053,
    35: 1.055
  },
  '10X': {
    4: 0.938,
    5: 0.951,
    6: 0.962,
    7: 0.973,
    8: 0.982,
    9: 0.991,
    10: 1.000,
    11: 1.005,
    12: 1.009,
    13: 1.014,
    14: 1.018,
    15: 1.023,
    16: 1.026,
    17: 1.030,
    18: 1.033,
    19: 1.037,
    20: 1.040,
    22: 1.044,
    24: 1.048,
    26: 1.051,
    28: 1.052,
    30: 1.054,
    32: 1.057,
    35: 1.061
  }
};

Map<String, Map<double, double>> scatterPatient = {
  '6X': {
    4: 0.978,
    5: 0.978,
    6: 0.984,
    7: 0.988,
    8: 0.992,
    9: 0.996,
    10: 1.000,
    11: 1.003,
    12: 1.006,
    13: 1.008,
    14: 1.011,
    15: 1.014,
    16: 1.015,
    17: 1.016,
    18: 1.017,
    19: 1.017,
    20: 1.019,
    22: 1.023,
    24: 1.026,
    26: 1.030,
    28: 1.031,
    30: 1.034,
    32: 1.037,
    35: 1.041
  },
  '10X': {
    4: 0.986,
    5: 0.986,
    6: 0.991,
    7: 0.994,
    8: 0.997,
    9: 0.999,
    10: 1.000,
    11: 1.000,
    12: 1.002,
    13: 1.002,
    14: 1.004,
    15: 1.004,
    16: 1.006,
    17: 1.007,
    18: 1.008,
    19: 1.009,
    20: 1.011,
    22: 1.013,
    24: 1.016,
    26: 1.017,
    28: 1.018,
    30: 1.018,
    32: 1.019,
    35: 1.019
  }
};

const Map<String, List<double>> mapDefaultDepthComposite = {
  '6X': [
    0,
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
    21,
    22,
    23,
    24,
    25,
    26,
    27,
    28,
    29,
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
    0,
    1,
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
    21,
    22,
    23,
    24,
    25,
    26,
    27,
    28,
    29,
    30
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

//endregion composite