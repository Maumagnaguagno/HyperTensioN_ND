# Domain dependent methods

# (:method (hospitalScenario)
#   ((patient ?patient))
#   ((seekHelp ?patient) (processPatient ?patient))
# )

def hospitalScenario_case0
  subtasks = []
  @state[PATIENT].each {|terms|
    if terms.size == 1
      patient = terms[0]
      subtasks.push(
        ['seekHelp', patient],
        ['processPatient', patient]
      )
    end
  }
  yield subtasks
end

# (:method (testCommitments)
#   (
#     (commitment C1 ?c1 ?d1 ?a1)
#     (commitment C2 ?c2 ?d2 ?a2)
#     (commitment C3 ?c3 ?d3 ?a3)
#     (commitment C4 ?c4 ?d4 ?a4)
#     (commitment C5 ?c5 ?d5 ?a5)
#     (commitment C6 ?c6 ?d6 ?a6)
#     (commitment C7 ?c7 ?d7 ?a7)
#     (commitment C8 ?c8 ?d8 ?a8)
#   )
#   (
#     (testCommitment C1 ?c1 ?cv1 satisfied)
#     (testCommitment C2 ?c2 ?cv2 satisfied)
#     (testCommitment C3 ?c3 ?cv3 satisfied)
#     (testCommitment C4 ?c4 ?cv4 satisfied)
#     (testCommitment C5 ?c5 ?cv5 satisfied)
#     (testCommitment C6 ?c6 ?cv6 satisfied)
#     (testCommitment C7 ?c7 ?cv7 satisfied)
#     (testCommitment C8 ?c8 ?cv8 satisfied)
#   )
# )

def testCommitments_case0
  c1 = ''
  d1 = ''
  a1 = ''
  c2 = ''
  d2 = ''
  a2 = ''
  c3 = ''
  d3 = ''
  a3 = ''
  c4 = ''
  d4 = ''
  a4 = ''
  c5 = ''
  d5 = ''
  a5 = ''
  c6 = ''
  d6 = ''
  a6 = ''
  c7 = ''
  d7 = ''
  a7 = ''
  c8 = ''
  d8 = ''
  a8 = ''
  generate(
    [
      [COMMITMENT, C1, c1, d1, a1],
      [COMMITMENT, C2, c2, d2, a2],
      [COMMITMENT, C3, c3, d3, a3],
      [COMMITMENT, C4, c4, d4, a4],
      [COMMITMENT, C5, c5, d5, a5],
      [COMMITMENT, C6, c6, d6, a6],
      [COMMITMENT, C7, c7, d7, a7],
      [COMMITMENT, C8, c8, d8, a8]
    ],
    [], c1, d1, a1, c2, d2, a2, c3, d3, a3, c4, d4, a4, c5, d5, a5, c6, d6, a6, c7, d7, a7, c8, d8, a8
  ) {
    yield [
      ['testCommitment', C1, c1, '', 'satisfied'],
      ['testCommitment', C2, c2, '', 'satisfied'],
      ['testCommitment', C3, c3, '', 'satisfied'],
      ['testCommitment', C4, c4, '', 'satisfied'],
      ['testCommitment', C5, c5, '', 'satisfied'],
      ['testCommitment', C6, c6, '', 'satisfied'],
      ['testCommitment', C7, c7, '', 'satisfied'],
      ['testCommitment', C8, c8, '', 'satisfied'],
    ]
  }
end

# (:method (seekHelp ?patient)
#   ((patient ?patient) (physician ?physician) (radiologist ?radiologist) (commitment C1 ?Ci1 ?physician ?patient))
#   ((!create C1 ?Ci1 ?physician ?patient (?patient)) (!requestAssessment ?patient ?physician))
# )

def seekHelp_case0(patient)
  physician = ''
  ci1 = ''
  generate(
    [
      [PATIENT, patient],
      [PHYSICIAN, physician],
      [COMMITMENT, C1, ci1, physician, patient]
    ],
    [], physician, ci1
  ) {
    yield [
      ['create', C1, ci1, physician, patient, list(patient)],
      ['requestAssessment', patient, physician]
    ]
  }
end

# (:method (processPatient ?patient)
#   process-patient-healthy
#   (
#     (patient ?patient) (physician ?physician) (commitment C1 ?Ci ?physician ?patient) (radiologist ?radiologist)
#     ;(conditional C1 ?Ci ?Cv)
#   )
#   ((performImagingTests ?patient) (performPathologyTests ?patient) (deliverDiagnostics ?patient))
# )

def processPatient_process_patient_healthy(patient)
  if @state[COMMITMENT].any? {|terms| terms.size == 4 and terms[0] == C1 and terms[3] == patient and state(PATIENT, patient) and state(PHYSICIAN, terms[2])}
    yield [
      ['performImagingTests', patient],
      ['performPathologyTests', patient],
      ['deliverDiagnostics', patient]
    ]
  end
end

# (:method (performImagingTests ?patient)
#   imaging
#   (
#     (patient ?patient) (physician ?physician) (commitment C1 ?Ci ?physician ?patient)
#     (radiologist ?radiologist)
#     (pathologist ?pathologist)
#     ;(conditional C1 ?Ci ?Cv)
#     (commitment C2 ?Ci2 ?patient ?physician)
#     (commitment C5 ?Ci5 ?radiologist ?physician)
#   )
#   (
#     (!create C2 ?Ci2 ?patient ?physician (?radiologist))
#     (!create C5 ?Ci5 ?radiologist ?physician (?pathologist))
#     (!requestImaging ?physician ?patient ?radiologist)
#     (attendTest ?patient)
#   )
# )

def performImagingTests_imaging(patient)
  physician = ''
  ci = ''
  radiologist = ''
  pathologist = ''
  ci2 = ''
  ci5 = ''
  generate(
    [
      [PATIENT, patient],
      [PHYSICIAN, physician],
      [COMMITMENT, C1, ci, physician, patient],
      [RADIOLOGIST, radiologist],
      [PATHOLOGIST, pathologist],
      [COMMITMENT, C2, ci2, patient, physician],
      [COMMITMENT, C5, ci5, radiologist, physician]
    ],
    [], physician, ci, radiologist, pathologist, ci2, ci5
  ) {
    yield [
      ['create', C2, ci2, patient, physician, list(radiologist)],
      ['create', C5, ci5, radiologist, physician, list(pathologist)],
      ['requestImaging', physician, patient, radiologist],
      ['attendTest', patient]
    ]
  }
end

# (:method (performPathologyTests ?patient)
#   biopsy-unnecessary
#   ((patient ?patient) (physician ?physician) (commitment C1 ?Ci ?physician ?patient) (radiologist ?radiologist))
#   ()
# )

def performPathologyTests_biopsy_unnecessary(patient)
  yield [] if @state[COMMITMENT].any? {|terms| terms.size == 4 and terms[0] == C1 and terms[3] == patient and state(PATIENT, patient) and state(PHYSICIAN, terms[2])}
end

# (:method (performPathologyTests ?patient)
#   imaging-plus-biopsy
#   (
#     (patient ?patient) (physician ?physician)
#     (radiologist ?radiologist)
#     (pathologist ?pathologist)
#     ;(conditional C1 ?Ci ?Cv)
#     (commitment C3 ?Ci3 ?patient ?physician)
#     (commitment C4 ?Ci4 ?radiologist ?physician)
#   )
#   (
#     (!create C3 ?Ci3 ?patient ?physician (?radiologist))
#     (!create C4 ?Ci4 ?radiologist ?physician (?pathologist))
#     (!requestBiopsy ?physician ?patient ?radiologist)
#     (attendTest ?patient)
#   )
# )

def performPathologyTests_imaging_plus_biopsy(patient)
  physician = ''
  radiologist = ''
  pathologist = ''
  ci = ''
  ci3 = ''
  ci4 = ''
  generate(
    [
      [PATIENT, patient],
      [PHYSICIAN, physician],
      [RADIOLOGIST, radiologist],
      [PATHOLOGIST, pathologist],
      [COMMITMENT, C3, ci3, patient, physician],
      [COMMITMENT, C4, ci4, radiologist, physician]
    ],
    [], physician, radiologist, pathologist, ci, ci3, ci4
  ) {
    yield [
      ['create', C3, ci3, patient, physician, list(radiologist)],
      ['create', C4, ci4, radiologist, physician, list(pathologist)],
      ['requestBiopsy', physician, patient, radiologist],
      ['attendTest', patient]
    ]
  }
end

# (:method (attendTest ?patient)
#   attend-imaging
#   ((patient ?patient) (physician ?physician) (radiologist ?radiologist) (iAppointmentRequested ?patient ?radiologist) (not (iAppointmentKept ?patient ?radiologist)))
#   ((!performImaging ?radiologist ?patient ?physician))
#   attend-biopsy
#   ((patient ?patient) (physician ?physician) (radiologist ?radiologist) (bAppointmentRequested ?patient ?radiologist) (not (bAppointmentKept ?patient ?radiologist)))
#   ((!performBiopsy ?radiologist ?patient ?physician))
# )

def attendTest_attend_imaging(patient)
  physician = ''
  radiologist = ''
  generate(
    [
      [PATIENT, patient],
      [PHYSICIAN, physician],
      [RADIOLOGIST, radiologist],
      [IAPPOINTMENTREQUESTED, patient, radiologist]
    ],
    [
      [IAPPOINTMENTKEPT, patient, radiologist]
    ], physician, radiologist
  ) {
    yield [['performImaging', radiologist, patient, physician]]
  }
end

def attendTest_attend_biopsy(patient)
  physician = ''
  radiologist = ''
  generate(
    [
      [PATIENT, patient],
      [PHYSICIAN, physician],
      [RADIOLOGIST, radiologist],
      [BAPPOINTMENTREQUESTED, patient, radiologist]
    ],
    [
      [BAPPOINTMENTKEPT, patient, radiologist]
    ], physician, radiologist
  ) {
    yield [['performBiopsy', radiologist, patient, physician]]
  }
end

# (:method (attendTest ?patient)
#   no-show-imaging
#   ((patient ?patient) (physician ?physician) (radiologist ?radiologist) (iAppointmentRequested ?patient ?radiologist) (not (iAppointmentKept ?patient ?radiologist)))
#   () ; No show
#   no-show-biopsy
#   ((patient ?patient) (physician ?physician) (radiologist ?radiologist) (bAppointmentRequested ?patient ?radiologist) (not (bAppointmentKept ?patient ?radiologist)))
#   ()
# )

def attendTest_no_show_imaging(patient)
  yield [] if @state[IAPPOINTMENTREQUESTED].any? {|terms| terms.size == 2 and terms[0] == patient and state(PATIENT, patient) and state(RADIOLOGIST, terms[1]) and not state(IAPPOINTMENTKEPT, patient, terms[1])}
end

def attendTest_no_show_biopsy(patient)
  yield [] if @state[BAPPOINTMENTREQUESTED].any? {|terms| terms.size == 2 and terms[0] == patient and state(PATIENT, patient) and state(RADIOLOGIST, terms[1]) and not state(BAPPOINTMENTKEPT, patient, terms[1])}
end

# (:method (deliverDiagnostics ?patient)
#   only-imaging
#   ((patient ?patient) (physician ?physician) (radiologist ?radiologist) (iAppointmentKept ?patient ?radiologist) (not (biopsyRequested ?physician ?patient)))
#   (
#     (!requestRadiologyReport ?physician ?radiologist ?patient)
#     (!sendRadiologyReport ?radiologist ?physician ?patient)
#     (!generateTreatmentPlan ?physician ?patient)
#   )
#   imaging-biopsy-integrated
#   ((patient ?patient) (physician ?physician) (radiologist ?radiologist) (pathologist ?pathologist) (iAppointmentKept ?patient ?radiologist) (bAppointmentKept ?patient ?radiologist))
#   (
#     (!requestRadiologyReport ?physician ?radiologist ?patient)
#     (!requestPathologyReport ?physician ?radiologist ?pathologist ?patient)
#     (!sendRadiologyReport ?radiologist ?physician ?patient)
#     (!sendPathologyReport ?radiologist ?physician ?pathologist ?patient)
#     (!sendIntegratedReport ?radiologist ?pathologist ?patient ?physician)
#     (!generateTreatmentPlan ?physician ?patient)
#   )
# )

def deliverDiagnostics_only_imaging(patient)
  physician = ''
  radiologist = ''
  generate(
    [
      [PATIENT, patient],
      [PHYSICIAN, physician],
      [RADIOLOGIST, radiologist],
      [IAPPOINTMENTKEPT, patient, radiologist]
    ],
    [
      [BIOPSYREQUESTED, physician, patient]
    ], physician, radiologist
  ) {
    yield [
      ['requestRadiologyReport', physician, radiologist, patient],
      ['sendRadiologyReport', radiologist, physician, patient],
      ['generateTreatmentPlan', physician, patient]
    ]
  }
end

def deliverDiagnostics_imaging_biopsy_integrated(patient)
  physician = ''
  radiologist = ''
  pathologist = ''
  generate(
    [
      [PATIENT, patient],
      [PHYSICIAN, physician],
      [RADIOLOGIST, radiologist],
      [PATHOLOGIST, pathologist],
      [IAPPOINTMENTKEPT, patient, radiologist],
      [BAPPOINTMENTKEPT, patient, radiologist]
    ],
    [], physician, radiologist, pathologist
  ) {
    yield [
      ['requestRadiologyReport', physician, radiologist, patient],
      ['requestPathologyReport', physician, radiologist, pathologist, patient],
      ['sendRadiologyReport', radiologist, physician, patient],
      ['sendPathologyReport', radiologist, physician, pathologist, patient],
      ['sendIntegratedReport', radiologist, pathologist, patient, physician],
      ['generateTreatmentPlan', physician, patient]
    ]
  }
end