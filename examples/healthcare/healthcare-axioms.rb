# Domain specific axioms
# C1(PHYSICIAN, PATIENT, diagnosisRequested ^ -vio(C2) ^ -vio(C3), diagnosisProvided)
# C2(PATIENT, PHYSICIAN, iAppointmentRequested, iAppointmentKept)
# C3(PATIENT, PHYSICIAN, bAppointmentRequested, bAppointmentKept)
# C4(RADIOLOGIST, PHYSICIAN, imagingRequested ^ iAppointmentKept, imagingResultsReported)
# C5(RADIOLOGIST, PHYSICIAN, biopsyRequested ^ bAppointmentKept, radPathResultsReported)
# C6(PATHOLOGIST, RADIOLOGIST, pathologyRequested ^ tissueProvided, pathResultsReported)
# C7(REGISTRAR, PATHOLOGIST, reportPatientWithCancer, addPatientToRegistry)
# C8(REGISTRAR, HOSPITAL, patientReportedToRegistrar, addPatientToCancerRegistry)
# C9(HOSPITAL, PHYSICIAN, vio(C5) ^ escalate, create(C5') ^ create(D2')) - Does not work because it depends D5
#; (:- (q ?c C9 ) (and (commitment ?c ?ci ?d ?a) (var ?c ?ci ) (and (create ?C5) (create ?D2)) ) )
# C10(TUMORBOARD, RADIOLOGIST, radRequestsAssessment, TBAgreesPath _ TBDisagreesPath)
# C11(TUMORBOARD, PHYSICIAN, phyRequestsAssessment, TBAgreesRad _ TBDisagreesRad)
# C12(TUMORBOARD, PATIENT, patRequestsAssessment, TBAgreesPCP _ TBDisagreesPCP)

def p(c, parameter1, t)
  @state['commitment'].any? {|cterms|
    if cterms.size == 4 and cterms[0] == c and state('var', c, cterms[1], t)
      d = cterms[2]
      a = cterms[3]
      case parameter1
      when C1 # (:- (p ?c C1 (?t)) (and (commitment ?c ?ci ?d ?a) (var ?c ?ci (?t)) (and (diagnosisRequested ?a ?d) (not (violated ?c C2 (?t))) (not (violated ?c C3 (?t))))))
        state('diagnosisRequested', a, d) and not violated(c, C2, t) and not violated(c, C3, t)
      when C2 # (:- (p ?c C2 (?t)) (and (commitment ?c ?ci ?d ?a) (var ?c ?ci (?t)) (and (iAppointmentRequested ?d ?radiologist))))
        @state['iAppointmentRequested'].any? {|terms| terms.size == 2 and terms[0] == d}
      when C3 # (:- (p ?c C3 (?t)) (and (commitment ?c ?ci ?d ?a) (var ?c ?ci (?t)) (and (bAppointmentRequested ?d ?pathologist))))
        @state['bAppointmentRequested'].any? {|terms| terms.size == 2 and terms[0] == d}
      when C4 # (:- (p ?c C4 (?t)) (and (commitment ?c ?ci ?d ?a) (var ?c ?ci (?t)) (and (imagingRequested ?a ?patient) (iAppointmentKept ?patient ?d))))
        @state['imagingRequested'].any? {|terms| terms.size == 2 and terms[0] == a and state('iAppointmentKept', terms[1], d)}
      when C5 # (:- (p ?c C5 (?t)) (and (commitment ?c ?ci ?d ?a) (var ?c ?ci (?t)) (and (biopsyRequested ?a ?patient) (bAppointmentKept ?patient ?d))))
        @state['biopsyRequested'].any? {|terms| terms.size == 2 and terms[0] == a and state('bAppointmentKept', terms[1], d)}
      when C6 # (:- (p ?c C6 (?t)) (and (commitment ?c ?ci ?d ?a) (var ?c ?ci (?t)) (and (pathologyRequested ?physician ?d ?patient) (tissueProvided ?patient))))
        @state['pathologyRequested'].any? {|terms| terms.size == 3 and terms[1] == d and state('tissueProvided', terms[2])}
      when C7 # (:- (p ?c C7 (?t)) (and (commitment ?c ?ci ?d ?a) (var ?c ?ci (?t)) (and (patientHasCancer ?patient))))
        @state['patientReportedToRegistrar'].any? {|terms| terms.size == 2 and terms[1] == d}
      #when C8 # (:- (p ?c C8 (?t)) (and (commitment ?c ?ci ?d ?a) (var ?c ?ci (?t)) (and (patientReportedToRegistrar ?patient ?d))))
      #  @state['patientReportedToRegistrar'].any? {|terms| terms[1] == d}
      #when C9 # (:- (p ?c C9 (?t)) (and (commitment ?c ?ci ?d ?a) (var ?c ?ci (?t)) (and (violated ?c C5 ?t) (escalate))))
      #  violated(c, C5, t) and state('escalate')
      #when C10 # (:- (p ?c C10 (?t)) (and (commitment ?c ?ci ?d ?a) (var ?c ?ci (?t)) (and (radRequestsAssessment))))
      #  state('radRequestsAssessment')
      #when C11 # (:- (p ?c C11 (?t)) (and (commitment ?c ?ci ?d ?a) (var ?c ?ci (?t)) (and (phyRequestsAssessment))))
      #  state('phyRequestsAssessment')
      #when C12 # (:- (p ?c C12 (?t)) (and (commitment ?c ?ci ?d ?a) (var ?c ?ci (?t)) (and (patRequestsAssessment))))
      #  state('patRequestsAssessment')
      end
    end
  }
end

def q(c, parameter1, t)
  @state['commitment'].any? {|cterms|
    if cterms.size == 4 and cterms[0] == c and state('var', c, cterms[1], t)
      d = cterms[2]
      a = cterms[3]
      case parameter1
      when C1 # (:- (q ?c C1 (?t)) (and (commitment ?c ?ci ?d ?a) (var ?c ?ci (?t)) (and (diagnosisProvided ?d ?a))))
        @state['diagnosisProvided'].any? {|terms| terms.size == 2 and terms[0] == d and terms[1] == a}
      when C2 # (:- (q ?c C2 (?t)) (and (commitment ?c ?ci ?d ?a) (var ?c ?ci (?t)) (and (iAppointmentKept ?d ?radiologist))))
        @state['iAppointmentKept'].any? {|terms| terms.size == 2 and terms[0] == d}
      when C3 # (:- (q ?c C3 (?t)) (and (commitment ?c ?ci ?d ?a) (var ?c ?ci (?t)) (and (bAppointmentKept ?d ?pathologist))))
        @state['bAppointmentKept'].any? {|terms| terms.size == 2 and terms[0] == d}
      when C4 # (:- (q ?c C4 (?t)) (and (commitment ?c ?ci ?d ?a) (var ?c ?ci (?t)) (and (imagingResultsReported ?d ?a ?patient))))
        @state['imagingResultsReported'].any? {|terms| terms.size == 3 and terms[0] == d and terms[1] == a}
      when C5 # (:- (q ?c C5 (?t)) (and (commitment ?c ?ci ?d ?a) (var ?c ?ci (?t)) (and (radPathResultsReported ?d ?a ?patient))))
        @state['radPathResultsReported'].any? {|terms| terms.size == 3 and terms[0] == d and terms[1] == a}
      when C6 # (:- (q ?c C6 (?t)) (and (commitment ?c ?ci ?d ?a) (var ?c ?ci (?t)) (and (pathResultsReported ?a ?physician ?patient))))
        @state['pathResultsReported'].any? {|terms| terms.size == 3 and terms[0] == a}
      when C7 # (:- (q ?c C7 (?t)) (and (commitment ?c ?ci ?d ?a) (var ?c ?ci (?t)) (and (patientReportedToRegistrar ?patient ?registrar))))
        @state['inRegistry'].any? {|terms| terms.size == 1}
      #when C8 # (:- (q ?c C8 (?t)) (and (commitment ?c ?ci ?d ?a) (var ?c ?ci (?t)) (and (inRegistry ?patient))))
      #  @state['inRegistry'].any? {|terms| terms.size == 1}
      #when C9 # (:- (q ?c C9 (?t)) (and (commitment ?c ?ci ?d ?a) (var ?c ?ci (?t)) (and (not (null ?c C5 ?ci)) (not (null ?c D5 ?ci)))))
      #  not null(c, C5, ci) and not null(c, 'D5', ci)
      #when C10 # (:- (q ?c C10 (?t)) (and (commitment ?c ?ci ?d ?a) (var ?c ?ci (?t)) (or (TBAgreesPath) (TBDisagreesPath))))
      #  state('TBAgreesPath') or state('TBDisagreesPath')
      #when C11 # (:- (q ?c C11 (?t)) (and (commitment ?c ?ci ?d ?a) (var ?c ?ci (?t)) (or (TBAgreesRad) (TBDisagreesRad))))
      #  state('TBAgreesRad') or state('TBDisagreesRad')
      #when C12 # (:- (q ?c C12 (?t)) (and (commitment ?c ?ci ?d ?a) (var ?c ?ci (?t)) (or (TBAgreesPCP) (TBDisagreesPCP))))
      #  state('TBAgreesPCP') or state('TBDisagreesPCP')
      end
    end
  }
end

# G1 = G(PHYSICIAN, diagnosisRequested, - diagnosisRequested)
# G2 = G(PATIENT, diagnosisRequested, - diagnosisRequested)
# G3 = G(RADIOLOGIST, imagingRequested ^ iAppointmentRequested, - imagingRequested v - iAppointmentRequested)
# G4 = G(PHYSICIAN, imgagingRequested ^ iAppointmentRequested, - imagingRequested v - iAppointmentRequested)

# (:- (pg ?g ?gn (?t)) (and (goal ?g ?gi ?a) ) )

def pg(g, gn, t)
  if gn == G1 or gn == G2 or gn == G3 or gn == G4 or
     gn == G6 or gn == G7 or gn == G8 or gn == G9 or
     gn == G11 or gn == G12 or gn == G13 or gn == G15 or
     gn == G16 or gn == G17 or gn == G18 or gn == G19
    @state['goal'].any? {|terms| terms.size == 3 and terms[0] == g}
  end
end

# (:- (s ?g G1 (?t)) (and (goal ?g ?gi ?a) (var ?g ?gi (?t)) (diagnosisRequested ?patient ?physician) ) )
# (:- (s ?g G2 (?t)) (and (goal ?g ?gi ?a) (var ?g ?gi (?t)) (diagnosisRequested ?patient ?physician) ) )
# (:- (s ?g G3 (?t)) (and (goal ?g ?gi ?a) (var ?g ?gi (?t)) (imagingRequested ?physician ?patient) (iAppointmentRequested ?patient ?radiologist) ) )
# (:- (s ?g G4 (?t)) (and (goal ?g ?gi ?a) (var ?g ?gi (?t)) (imagingRequested ?physician ?patient) ) )
# (:- (s ?g G6 (?t)) (and (goal ?g ?gi ?a) (varG ?g ?gi (?t)) (iAppointmentKept ?patient ?radiologist) ) )
# (:- (s ?g G7 (?t)) (and (goal ?g ?gi ?a) (varG ?g ?gi (?t)) (imagingResultsReported ?radiologist ?physician ?patient) ) )
# (:- (s ?g G8 (?t)) (and (goal ?g ?gi ?a) (varG ?g ?gi (?t)) (biopsyRequested ?physician ?patient) (bAppointmentRequested ?patient ?pathologist) ) )
# (:- (s ?g G9 (?t)) (and (goal ?g ?gi ?a) (varG ?g ?gi (?t)) (biopsyRequested ?physician ?patient) (bAppointmentRequested ?patient ?pathologist) ) )
# (:- (s ?g G11 (?t)) (and (goal ?g ?gi ?a) (varG ?g ?gi (?t)) (bAppointmentKept ?patient ?pathologist) ) )
# (:- (s ?g G12 (?t)) (and (goal ?g ?gi ?a) (varG ?g ?gi (?t)) (pathologyRequested ?physician ?d ?patient) (tissueProvided ?patient)) )
# (:- (s ?g G13 (?t)) (and (goal ?g ?gi ?a) (varG ?g ?gi (?t)) (pathologyRequested ?physician ?d ?patient) (tissueProvided ?patient)) )
# (:- (s ?g G15 (?t)) (and (goal ?g ?gi ?a) (varG ?g ?gi (?t)) (pathResultsReported ?pathologist ?physician ?patient)) )
# (:- (s ?g G16 (?t)) (and (goal ?g ?gi ?a) (varG ?g ?gi (?t)) (integratedReport ?patient ?physician) ) )
# (:- (s ?g G17 (?t)) (and (goal ?g ?gi ?a) (varG ?g ?gi (?t)) (patientReportedToRegistrar ?patient ?registrar)) )
# (:- (s ?g G18 (?t)) (and (goal ?g ?gi ?a) (varG ?g ?gi (?t)) (patientReportedToRegistrar ?patient ?registrar)) )
# (:- (s ?g G19 (?t)) (and (goal ?g ?gi ?a) (varG ?g ?gi (?t)) (inRegistry ?patient)) )

def s(g, gn, t)
  @state['goal'].any? {|terms|
    if terms.size == 3 and terms[0] == g and state('varG', g, terms[1], t)
      case gn
      when G1, G2 then @state['diagnosisRequested'].any? {|terms2| terms2.size == 2}
      when G3 then @state['imagingRequested'].any? {|terms2| terms2.size == 2 and @state['iAppointmentRequested'].any? {|terms3| terms3.size == 2 and terms2[1] == terms3[0]}}
      when G4 then @state['imagingRequested'].any? {|terms2| terms2.size == 2}
      when G6 then @state['iAppointmentKept'].any? {|terms2| terms2.size == 2}
      when G7 then @state['imagingResultsReported'].any? {|terms2| terms2.size == 3}
      when G8, G9 then @state['biopsyRequested'].any? {|terms2| terms2.size == 2 and @state['bAppointmentRequested'].any? {|terms3| terms3.size == 2 and terms2[1] == terms3[0]}}
      when G11 then @state['bAppointmentKept'].any? {|terms2| terms2.size == 2}
      when G12, G13 then @state['pathologyRequested'].any? {|terms2| terms2.size == 3 and state('tissueProvided', terms2[2])}
      when G15 then @state['pathResultsReported'].any? {|terms2| terms2.size == 3}
      when G16 then @state['integratedReport'].any? {|terms2| terms2.size == 2}
      when G17, G18 then @state['patientReportedToRegistrar'].any? {|terms2| terms2.size == 2}
      when G19 then @state['inRegistry'].any? {|terms2| terms2.size == 1}
      end
    end
  }
end

# (:- (f ?g G1 (?t)) (and (goal ?g ?gi ?a) (var ?g ?gi (?t)) (dontknow ?patient) ))
# (:- (f ?g G2 (?t)) (and (goal ?g ?gi ?a) (var ?g ?gi (?t)) (dontknow ?patient) ))
# (:- (f ?g G3 (?t)) (and (goal ?g ?gi ?a) (var ?g ?gi (?t)) (dontknow ?patient) ))
# (:- (f ?g G4 (?t)) (and (goal ?g ?gi ?a) (var ?g ?gi (?t)) (dontknow ?patient) ))

def f(g, gn, t)
  if gn == G1 or gn == G2 or gn == G3 or gn == G4 or
     gn == G6 or gn == G7 or gn == G8 or gn == G9 or
     gn == G11 or gn == G12 or gn == G13 or gn == G15 or
     gn == G16 or gn == G17 or gn == G18 or gn == G19
    @state['goal'].any? {|terms| terms.size == 3 and terms[0] == g and state('varG', g, terms[1], t)} and @state['dontknow'].any? {|terms| terms.size == 1}
  end
end