/// Calcule les intérêts composés sur un investissement ou un prêt.
Map<String, dynamic> calculateInterest(
    double principal, double annualRate, int years, double monthlyContribution, String interestCalculationMode) {
  double totalAmount = 0;
  double totalInvestment = 0;
  double totalInterestEarned = 0;
  List<Map<String, dynamic>> tableData = [];

  double runningTotal = principal; // Montant initial de l'investissement ou du prêt.
  double accumulatedInvestment = principal; // Total investi au fil du temps.

  // Boucle sur chaque année.
  for (int i = 1; i <= years; i++) {
    double annualContribution = monthlyContribution * 12; // Contribution annuelle totale.
    double interest = 0; // Intérêt accumulé pour l'année.

    // Calcule les intérêts en fonction du mode de calcul spécifié.
    if (interestCalculationMode == 'Annuel') {
      // Calcul des intérêts annuels.
      accumulatedInvestment += annualContribution;
      interest = runningTotal * (annualRate / 100);
      runningTotal += interest + annualContribution;
    } else if (interestCalculationMode == 'Mensuel') {
      // Calcul des intérêts mensuels.
      for (int j = 0; j < 12; j++) {
        accumulatedInvestment += monthlyContribution;
        interest += (runningTotal + monthlyContribution) * (annualRate / 100 / 12);
        runningTotal += monthlyContribution + (runningTotal + monthlyContribution) * (annualRate / 100 / 12);
      }
    } else if (interestCalculationMode == 'Journalier') {
      // Calcul des intérêts quotidiens.
      for (int j = 0; j < 365; j++) {
        double dailyContribution = monthlyContribution / 30; // Contribution quotidienne (approximation).
        accumulatedInvestment += dailyContribution;
        interest += (runningTotal + dailyContribution) * (annualRate / 100 / 365);
        runningTotal += dailyContribution + (runningTotal + dailyContribution) * (annualRate / 100 / 365);
      }
    }

    // Ajoute les résultats de l'année à tableData pour l'affichage.
    tableData.add({
      'year': DateTime.now().year + i - 1,
      'investment': accumulatedInvestment,
      'interest': interest,
      'balance': runningTotal,
    });
  }

  // Calcule les totaux finaux.
  totalAmount = runningTotal;
  totalInterestEarned = runningTotal - accumulatedInvestment;
  totalInvestment = accumulatedInvestment;

  return {
    'tableData': tableData, // Données pour chaque année.
    'totalAmount': totalAmount, // Montant total à la fin de la période.
    'totalInterestEarned': totalInterestEarned, // Total des intérêts gagnés.
    'totalInvestment': totalInvestment // Total investi sur toute la période.
  };
}
