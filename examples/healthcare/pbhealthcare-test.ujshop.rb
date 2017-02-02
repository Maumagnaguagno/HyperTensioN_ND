require_relative 'healthcare'

debug = ARGV.first == '-d'
max_plans = ARGV[1] ? ARGV[1].to_i : -1
min_prob  = ARGV[2] ? ARGV[2].to_f : 0

# Objects
alice = 'alice'
bob = 'bob'
clyde = 'clyde'
doug = 'doug'
evelyn = 'evelyn'
simhospital = 'simhospital'
satisfied = 'satisfied'

puts 'Test problem 1'
plan1 = Healthcare.problem(
  # Start
  {
    'patient' => [[alice]],
    'physician' => [[bob]],
    'radiologist' => [[clyde]],
    'pathologist' => [[doug]],
    'registrar' => [[evelyn]],
    'hospital' => [[simhospital]],
    'patientHasCancer' => [[alice]],
    'commitment' => [[C1, C1, bob, alice]],
    'var' => [],
    'varG' => [],
    'diagnosisRequested' => [],
    'iAppointmentRequested' => [],
    'iAppointmentKept' => [],
    'imagingScan' => [],
    'imagingRequested' => [],
    'imagingResultsReported' => [],
    'bAppointmentRequested' => [],
    'bAppointmentKept' => [],
    'biopsyReport' => [],
    'biopsyRequested' => [],
    'radiologyRequested' => [],
    'treatmentPlan' => [],
    'diagnosisProvided' => [],
    'tissueProvided' => [],
    'radPathResultsReported' => [],
    'pathResultsReported' => [],
    'patientReportedToRegistrar' => [],
    'inRegistry' => [],
    'TBAgreesPath' => [],
    'TBDisagreesPath' => [],
    'TBAgreesRad' => [],
    'TBDisagreesRad' => [],
    'TBAgreesPCP' => [],
    'TBDisagreesPCP' => [],
    'pathologyRequested' => [],
    'escalate' => [],
    'radRequestsAssessment' => [],
    'phyRequestsAssessment' => [],
    'patRequestsAssessment' => [],
    'integratedReport' => [],
    'reportNeedsReview' => [],
    'cancelled' => [],
    'released' => [],
    'expired' => [],
    'dropped' => [],
    'aborted' => [],
    'pending' => [],
    'activatedG' => [],
    'suspendedG' => [],
    'goal' => [],
    'dontknow' => []
  },
  # Tasks
  [
    ['create', C1, C1, bob, alice, list(alice)],
    ['requestAssessment', alice, bob],
    ['requestImaging', bob, alice, clyde],
    ['requestBiopsy', bob, alice, clyde],
    ['performImaging', clyde, alice, bob],
    ['performBiopsy', clyde, alice, bob],
    ['requestRadiologyReport', bob, clyde, alice],
    ['requestPathologyReport', bob, clyde, doug, alice],

    ['sendRadiologyReport', clyde, bob, alice],
    ['sendPathologyReport', clyde, bob, doug, alice],

    ['sendIntegratedReport', clyde, doug, alice, bob],
    ['generateTreatmentPlan', bob, alice],
    ['reportPatient', alice, doug, evelyn],
    ['addPatientToRegistry', alice, evelyn],
    ['requestPhysicianReportAssessment', alice, bob, simhospital],

    ['testCommitment', C1, C1, list(alice), satisfied],
  ],
  # Debug
  debug,
  # Maximum plans found
  max_plans,
  # Minimum probability for plans
  min_prob
)

Kernel.abort('Problem 1 failed to generate expected plan') if plan1 != [
  [0.42, 0,
    ['create', C1, C1, bob, alice, list(alice)],
    ['requestAssessment', alice, bob],
    ['requestImaging', bob, alice, clyde],
    ['requestBiopsy', bob, alice, clyde],
    ['performImaging_success', clyde, alice, bob],
    ['performBiopsy_success', clyde, alice, bob],
    ['requestRadiologyReport', bob, clyde, alice],
    ['requestPathologyReport', bob, clyde, doug, alice],
    ['sendRadiologyReport', clyde, bob, alice],
    ['sendPathologyReport', clyde, bob, doug, alice],
    ['sendIntegratedReport', clyde, doug, alice, bob],
    ['generateTreatmentPlan', bob, alice],
    ['reportPatient', alice, doug, evelyn],
    ['addPatientToRegistry', alice, evelyn],
    ['requestPhysicianReportAssessment', alice, bob, simhospital],
    ['invisible_testSuccess', C1, C1, list(alice), satisfied]
  ],
  [0.7 * 0.4, 0,
    ['create', C1, C1, bob, alice, list(alice)],
    ['requestAssessment', alice, bob],
    ['requestImaging', bob, alice, clyde],
    ['requestBiopsy', bob, alice, clyde],
    ['performImaging_success', clyde, alice, bob],
    ['performBiopsy_failure', clyde, alice, bob]
  ],
  [0.3, 0,
    ['create', C1, C1, bob, alice, list(alice)],
    ['requestAssessment', alice, bob],
    ['requestImaging', bob, alice, clyde],
    ['requestBiopsy', bob, alice, clyde],
    ['performImaging_failure', clyde, alice, bob]
  ]
]

puts "\n\nTest problem 2"
plan2 = Healthcare.problem(
  # Start
  {
    'patient' => [[alice]],
    'physician' => [[bob]],
    'radiologist' => [[clyde]],
    'pathologist' => [[doug]],
    'registrar' => [[evelyn]],
    'hospital' => [[simhospital]],
    'patientHasCancer' => [[alice]],
    'commitment' => [
      [C1, C1, bob, alice],
      [C2, C2, alice, bob],
      [C3, C3, alice, bob],
      [C4, C4, clyde, bob],
      [C5, C5, clyde, bob],
      [C6, C6, doug, clyde],
      [C7, C7, doug, simhospital],
      [C8, C8, evelyn, simhospital]
    ],
    'var' => [],
    'varG' => [],
    'diagnosisRequested' => [],
    'iAppointmentRequested' => [],
    'iAppointmentKept' => [],
    'imagingScan' => [],
    'imagingRequested' => [],
    'imagingResultsReported' => [],
    'bAppointmentRequested' => [],
    'bAppointmentKept' => [],
    'biopsyReport' => [],
    'biopsyRequested' => [],
    'radiologyRequested' => [],
    'treatmentPlan' => [],
    'diagnosisProvided' => [],
    'tissueProvided' => [],
    'radPathResultsReported' => [],
    'pathResultsReported' => [],
    'patientReportedToRegistrar' => [],
    'inRegistry' => [],
    'TBAgreesPath' => [],
    'TBDisagreesPath' => [],
    'TBAgreesRad' => [],
    'TBDisagreesRad' => [],
    'TBAgreesPCP' => [],
    'TBDisagreesPCP' => [],
    'pathologyRequested' => [],
    'escalate' => [],
    'radRequestsAssessment' => [],
    'phyRequestsAssessment' => [],
    'patRequestsAssessment' => [],
    'integratedReport' => [],
    'reportNeedsReview' => [],
    'cancelled' => [],
    'released' => [],
    'expired' => [],
    'dropped' => [],
    'aborted' => [],
    'activatedG' => [],
    'suspendedG' => [],
    'goal' => [],
    'dontknow' => []
  },
  # Tasks
  [
    ['create', C1, C1, bob, alice, list(alice)],
    ['requestAssessment', alice, bob],

    ['create', C2, C2, alice, bob, list(clyde)],
    ['create', C3, C3, alice, bob, list(clyde)],

    ['create', C4, C4, clyde, bob, list(doug)],
    ['create', C5, C5, clyde, bob, list(doug)],
    ['create', C6, C6, doug, clyde, list(bob, alice)],

    ['create', C7, C7, doug, simhospital, list(alice, evelyn)],
    ['create', C8, C8, evelyn, simhospital, list(alice)],

    ['requestImaging', bob, alice, clyde],
    ['requestBiopsy', bob, alice, clyde],
    ['performImaging', clyde, alice, bob],
    ['performBiopsy', clyde, alice, bob],

    ['testCommitment', C2, C2, list(clyde), satisfied],
    ['testCommitment', C3, C3, list(clyde), satisfied],

    ['requestRadiologyReport', bob, clyde, alice],
    ['requestPathologyReport', bob, clyde, doug, alice],

    ['sendRadiologyReport', clyde, bob, alice],
    ['sendPathologyReport', clyde, bob, doug, alice],

    ['testCommitment', C4, C4, list(doug), satisfied],
    ['testCommitment', C5, C5, list(doug), satisfied],
    ['testCommitment', C6, C6, list(bob, alice), satisfied],

    ['sendIntegratedReport', clyde, doug, alice, bob],
    ['generateTreatmentPlan', bob, alice],
    ['reportPatient', alice, doug, evelyn],

    ['testCommitment', C7, C7, list(alice, evelyn), satisfied],

    ['addPatientToRegistry', alice, evelyn],

    ['testCommitment', C8, C8, list(alice), satisfied],

    ['requestPhysicianReportAssessment', alice, bob, simhospital],

    ['testCommitment', C1, C1, list(alice), satisfied]
  ],
  # Debug
  debug,
  # Maximum plans found
  max_plans,
  # Minimum probability for plans
  min_prob
)

Kernel.abort('Problem 2 failed to generate expected plan') if plan2 != [
  [0.42, 0,
    ['create', C1, C1, bob, alice, list(alice)],
    ['requestAssessment', alice, bob],
    ['create', C2, C2, alice, bob, list(clyde)],
    ['create', C3, C3, alice, bob, list(clyde)],
    ['create', C4, C4, clyde, bob, list(doug)],
    ['create', C5, C5, clyde, bob, list(doug)],
    ['create', C6, C6, doug, clyde, list(bob, alice)],
    ['create', C7, C7, doug, simhospital, list(alice, evelyn)],
    ['create', C8, C8, evelyn, simhospital, list(alice)],
    ['requestImaging', bob, alice, clyde],
    ['requestBiopsy', bob, alice, clyde],
    ['performImaging_success', clyde, alice, bob],
    ['performBiopsy_success', clyde, alice, bob],
    ['invisible_testSuccess', C2, C2, list(clyde), satisfied],
    ['invisible_testSuccess', C3, C3, list(clyde), satisfied],
    ['requestRadiologyReport', bob, clyde, alice],
    ['requestPathologyReport', bob, clyde, doug, alice],
    ['sendRadiologyReport', clyde, bob, alice],
    ['sendPathologyReport', clyde, bob, doug, alice],
    ['invisible_testSuccess', C4, C4, list(doug), satisfied],
    ['invisible_testSuccess', C5, C5, list(doug), satisfied],
    ['invisible_testSuccess', C6, C6, list(bob, alice), satisfied],
    ['sendIntegratedReport', clyde, doug, alice, bob],
    ['generateTreatmentPlan', bob, alice],
    ['reportPatient', alice, doug, evelyn],
    ['invisible_testSuccess', C7, C7, list(alice, evelyn), satisfied],
    ['addPatientToRegistry', alice, evelyn],
    ['invisible_testSuccess', C8, C8, list(alice), satisfied],
    ['requestPhysicianReportAssessment', alice, bob, simhospital],
    ['invisible_testSuccess', C1, C1, list(alice), satisfied]
  ]
]

puts "\n\nTest problem 3"
plan3 = Healthcare.problem(
  # Start
  {
    'patient' => [[alice]],
    'physician' => [[bob]],
    'radiologist' => [[clyde]],
    'pathologist' => [[doug]],
    'registrar' => [[evelyn]],
    'hospital' => [[simhospital]],
    'patientHasCancer' => [[alice]],

    'commitment' => [
      [C1, C1, bob, alice],
      [C2, C2, alice, bob],
      [C3, C3, alice, bob],
      [C4, C4, clyde, bob],
      [C5, C5, clyde, bob],
      [C6, C6, doug, clyde],
      [C7, C7, doug, simhospital],
      [C8, C8, evelyn, simhospital]
    ],

    # Goals
    'goal' => [
      [G1, G1, bob],
      [G2, G2, alice],
      [G3, G3, clyde],
      [G4, G4, clyde],
      [G5, G5, doug]
    ],

    'var' => [],
    'varG' => [],
    'diagnosisRequested' => [],
    'iAppointmentRequested' => [],
    'iAppointmentKept' => [],
    'imagingScan' => [],
    'imagingRequested' => [],
    'imagingResultsReported' => [],
    'bAppointmentRequested' => [],
    'bAppointmentKept' => [],
    'biopsyReport' => [],
    'biopsyRequested' => [],
    'radiologyRequested' => [],
    'treatmentPlan' => [],
    'diagnosisProvided' => [],
    'tissueProvided' => [],
    'radPathResultsReported' => [],
    'pathResultsReported' => [],
    'patientReportedToRegistrar' => [],
    'inRegistry' => [],
    'TBAgreesPath' => [],
    'TBDisagreesPath' => [],
    'TBAgreesRad' => [],
    'TBDisagreesRad' => [],
    'TBAgreesPCP' => [],
    'TBDisagreesPCP' => [],
    'pathologyRequested' => [],
    'escalate' => [],
    'radRequestsAssessment' => [],
    'phyRequestsAssessment' => [],
    'patRequestsAssessment' => [],
    'integratedReport' => [],
    'reportNeedsReview' => [],
    'cancelled' => [],
    'released' => [],
    'dropped' => [],
    'aborted' => [],
    'expired' => [],
    'activatedG' => [],
    'suspendedG' => [],
    'dontknow' => []
  },
  # Tasks
  [
    ['consider', G1, G1, bob, list(alice)],
    ['activate', G1, G1, bob, list(alice)],
    
    # ['create', C1, C1, bob, alice, list(alice)],
    ['entice', G1, G1, list(alice), C1, C1, list(alice), bob, alice],
    
    # This is a vacuous definition of detach
    # ['consider', G2, G2, alice, list(bob)],
    # ['activate', G2, G2, alice, list(bob)],
    # Alice detaches
    ['detach', G2, G2, list(alice), C1, C1, list(alice), bob, alice],
    
    ['requestAssessment', alice, bob],

    ['testGoal', G1, G1, list(alice), satisfied],

    ['deliver', G3, G3, list(alice), C1, C1, list(alice), bob, alice],

    ['create', C2, C2, alice, bob, list(clyde)],
    ['create', C3, C3, alice, bob, list(clyde)],

    ['create', C4, C4, clyde, bob, list(doug)],
    ['create', C5, C5, clyde, bob, list(doug)],
    ['create', C6, C6, doug, clyde, list(bob, alice)],

    ['create', C7, C7, doug, simhospital, list(alice, evelyn)],
    ['create', C8, C8, evelyn, simhospital, list(alice)],
    
    ['requestImaging', bob, alice, clyde],
    ['requestBiopsy', bob, alice, clyde],
    ['performImaging', clyde, alice, bob],
    ['performBiopsy', clyde, alice, bob],
    
    ['testCommitment', C2, C2, list(clyde), satisfied],
    ['testCommitment', C3, C3, list(clyde), satisfied],
    
    ['requestRadiologyReport', bob, clyde, alice],
    ['requestPathologyReport', bob, clyde, doug, alice],

    ['sendRadiologyReport', clyde, bob, alice],
    ['sendPathologyReport', clyde, bob, doug, alice],
    
    ['testCommitment', C4, C4, list(doug), satisfied],
    ['testCommitment', C5, C5, list(doug), satisfied],
    ['testCommitment', C6, C6, list(bob, alice), satisfied],

    ['sendIntegratedReport', clyde, doug, alice, bob],
    ['generateTreatmentPlan', bob, alice],
    ['reportPatient', alice, doug, evelyn],
    
    ['testCommitment', C7, C7, list(alice, evelyn), satisfied],
    
    ['addPatientToRegistry', alice, evelyn],
    
    ['testCommitment', C8, C8, list(alice), satisfied],
    
    ['requestPhysicianReportAssessment', alice, bob, simhospital],
    
    ['testCommitment', C1, C1, list(alice), satisfied],
    ['testGoal', G2, G2, list(alice), satisfied],
    ['testGoal', G3, G3, list(alice), satisfied]
  ],
  # Debug
  debug,
  # Maximum plans found
  max_plans,
  # Minimum probability for plans
  min_prob
)