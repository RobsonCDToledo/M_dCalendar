let
  // Captura o Ano Atual.
  AnoAtual = Date.Year(DateTime.LocalNow()), 
  // Identifica através do ano atual, o primeiro dia a três anos atrás. 
  DataInicial = #date((AnoAtual - 2), 01, 01), 
  // Define a Data final igual ultimo dia do ano atual. 
  DataFinal = #date(AnoAtual, 12, 31), 
  // Define numero de dias total. 
  Dias = Duration.Days(Duration.From(DataFinal - DataInicial)) + 1, 
  // Dropa uma lista de datas.
  TabelaCalendario = List.Dates(DataInicial, Dias, #duration(1, 0, 0, 0)), 
  // Converte para tabela.
  Tabela = Table.FromList(TabelaCalendario, Splitter.SplitByNothing(), {"Data"}), 
  // Formata coluna como Data.
  TabelaFormatada = Table.TransformColumnTypes(Tabela, {{"Data", type date}}), 
  #"Ano Inserido" = Table.AddColumn(TabelaFormatada, "Ano", each Date.Year([Data]), Int64.Type), 
  #"Mês Inserido" = Table.AddColumn(#"Ano Inserido", "Mês", each Date.Month([Data]), Int64.Type), 
  #"Nome do Mês Inserido" = Table.AddColumn(
    #"Mês Inserido", 
    "Nome do Mês", 
    each Date.MonthName([Data]), 
    type text
  ),
  // Adicona coluna com identificar do trimestre do ano
  #"Trimestre Inserido" = Table.AddColumn(
    #"Nome do Mês Inserido", 
    "Trimestre", 
    each Date.QuarterOfYear([Data]), 
    Int64.Type
  ),
  // Formata o texto do identificador do trimestre 
  #"Sufixo Adicionado" = Table.TransformColumns(
    #"Trimestre Inserido", 
    {{"Trimestre", each Text.From(_, "pt-BR") & "ºTri", type text}}
  ), 
  // Adciona a semana do ano
  #"Semana do Ano Inserida" = Table.AddColumn(
    #"Sufixo Adicionado", 
    "Semana do Ano", 
    each Date.WeekOfYear([Data]), 
    Int64.Type
  ),
  // Adiciona a semana do mês
  #"Semana do Mês Inserida" = Table.AddColumn(
    #"Semana do Ano Inserida", 
    "Semana do Mês", 
    each Date.WeekOfMonth([Data]), 
    Int64.Type
  ),
  // Adiciona um indentificador de dias
  #"Dia Inserido" = Table.AddColumn(
    #"Semana do Mês Inserida", 
    "Dia", 
    each Date.Day([Data]), 
    Int64.Type
  ), 
  // Adciona o nome do dia
  #"Nome do Dia Inserido" = Table.AddColumn(
    #"Dia Inserido", 
    "Nome do Dia", 
    each Date.DayOfWeekName([Data]), 
    type text
  ),
  // Extrai os dois ultimos caracteres do ano 
  #"Últimos caracteres inseridos" = Table.AddColumn(
    #"Nome do Dia Inserido", 
    "Últimos caracteres", 
    each Text.End(Text.From([Ano], "pt-BR"), 2), 
    type text
  ),
  // Faz um join entre o Trimestre / ano
  #"Colunas Mescladas" = Table.CombineColumns(
    Table.TransformColumnTypes(#"Últimos caracteres inseridos", {{"Trimestre", type text}}, "pt-BR"), 
    {"Trimestre", "Últimos caracteres"}, 
    Combiner.CombineTextByDelimiter("-", QuoteStyle.None), 
    "dData_Trimestre Ano"
  ),
  // Abrevia o nome dos meses 
  #"Primeiros Caracteres Inseridos" = Table.AddColumn(
    #"Colunas Mescladas", 
    "Primeiros caracteres", 
    each Text.Start([Nome do Mês], 3), 
    type text
  ),
  // Abrevia o nome dos dias
  #"Primeiros Caracteres Inseridos1" = Table.AddColumn(
    #"Primeiros Caracteres Inseridos", 
    "Primeiros caracteres.1", 
    each Text.Start([Nome do Dia], 3), 
    type text
  ),
  // Formata o texto das colunas de nome dia e nome mês 
  #"Colocar Cada Palavra Em Maiúscula" = Table.TransformColumns(
    #"Primeiros Caracteres Inseridos1", 
    {
      {"Primeiros caracteres", Text.Proper, type text}, 
      {"Primeiros caracteres.1", Text.Proper, type text}, 
      {"Nome do Dia", Text.Proper, type text}, 
      {"Nome do Mês", Text.Proper, type text}
    }
  ),
  // Padroniza o nome das colunas inserindo a indetificação da tabela
  #"Colunas Renomeadas" = Table.RenameColumns(
    #"Colocar Cada Palavra Em Maiúscula", 
    {
      {"Data", "dData_Data"}, 
      {"Ano", "dData_Ano"}, 
      {"Mês", "dData_Mês"}, 
      {"Nome do Mês", "dData_Nome do Mês"}, 
      {"Semana do Ano", "dData_Semana do Ano"}, 
      {"Semana do Mês", "dData_Semana do Mês"}, 
      {"Dia", "dData_Dia"}, 
      {"Nome do Dia", "dData_Nome do Dia"}, 
      {"Primeiros caracteres", "dData_Mês Abreviado"}, 
      {"Primeiros caracteres.1", "dData_Dia da Semana Abreviado"}
    }
  ),
  // Formata o nome das semanas para reorganizar automaticamente 
  #"Coluna Condicional Adicionada" = Table.AddColumn(
    #"Colunas Renomeadas", 
    "dData_Semana_Mês_Nome", 
    each 
      if [dData_Semana do Mês] = 1 then
        "1º - Sem"
      else if [dData_Semana do Mês] = 2 then
        "2º - Sem"
      else if [dData_Semana do Mês] = 3 then
        "3º - Sem"
      else if [dData_Semana do Mês] = 4 then
        "4º - Sem"
      else if [dData_Semana do Mês] = 5 then
        "5º - Sem"
      else
        "6º - Sem"
  ), 
  // Função de Gauss para calcular a pascoa
  CalcularPascoa = (ano as number) as date =>
    let
      a   = Number.Mod(ano, 19), 
      b   = Number.IntegerDivide(ano, 100), 
      c   = Number.Mod(ano, 100), 
      d   = Number.IntegerDivide(b, 4), 
      e   = Number.Mod(b, 4), 
      f   = Number.IntegerDivide(b + 8, 25), 
      g   = Number.IntegerDivide(b - f + 1, 3), 
      h   = Number.Mod(19 * a + b - d - g + 15, 30), 
      i   = Number.IntegerDivide(c, 4), 
      k   = Number.Mod(c, 4), 
      l   = Number.Mod(32 + 2 * e + 2 * i - h - k, 7), 
      m   = Number.IntegerDivide(a + 11 * h + 22 * l, 451), 
      mes = Number.IntegerDivide(h + l - 7 * m + 114, 31), 
      dia = Number.Mod(h + l - 7 * m + 114, 31) + 1
    in
      #date(ano, mes, dia), 
  // Função para verificar se dia é feriado ou não
  EhFeriado = (data as date) as logical =>
    let
      ano = Date.Year(data), 
      mes = Date.Month(data), 
      dia = Date.Day(data), 
      pascoa = CalcularPascoa(ano), 
      sextaFeiraSanta = Date.AddDays(pascoa, - 2), 
      carnaval = Date.AddDays(pascoa, - 47), 
      segundaCarnaval = Date.AddDays(pascoa, - 48), 
      tercaCarnaval = Date.AddDays(pascoa, - 47), 
      corpusChristi = Date.AddDays(pascoa, 60), 
      // Lista de feriados nacionais fixos
      feriadosFixos = {#date(ano, 1, 1),  // Confraternização Universal
      #date(ano, 4, 21),  // Tiradentes
      #date(ano, 5, 1),  // Dia do Trabalhador
      #date(ano, 9, 7),  // Independência do Brasil
      #date(ano, 10, 12),  // Nossa Senhora Aparecida
      #date(ano, 11, 2),  // Finados
      #date(ano, 11, 15),  // Proclamação da República
      #date(ano, 12, 25) // Natal
      }, 
      // Lista de feriados móveis
      feriadosMoveis = {sextaFeiraSanta,  // Sexta-feira Santa
      pascoa,  // Páscoa
      segundaCarnaval,  // Segunda-feira de Carnaval
      tercaCarnaval,  // Terça-feira de Carnaval
      corpusChristi // Corpus Christi
      }, 
      // Combina todas as listas
      todosFeriados = feriadosFixos & feriadosMoveis
    in
      List.Contains(todosFeriados, data), 
  // Função para obter o nome dos feriados
  NomeFeriado = (data as date) as text =>
    let
      ano             = Date.Year(data), 
      mes             = Date.Month(data), 
      dia             = Date.Day(data), 
      pascoa          = CalcularPascoa(ano), 
      sextaFeiraSanta = Date.AddDays(pascoa, - 2), 
      carnaval        = Date.AddDays(pascoa, - 47), 
      segundaCarnaval = Date.AddDays(pascoa, - 48), 
      tercaCarnaval   = Date.AddDays(pascoa, - 47), 
      corpusChristi   = Date.AddDays(pascoa, 60)
    in
      if data = #date(ano, 1, 1) then
        "Confraternização Universal"
      else if data = #date(ano, 4, 21) then
        "Tiradentes"
      else if data = #date(ano, 5, 1) then
        "Dia do Trabalhador"
      else if data = #date(ano, 9, 7) then
        "Independência do Brasil"
      else if data = #date(ano, 10, 12) then
        "Nossa Senhora Aparecida"
      else if data = #date(ano, 11, 2) then
        "Finados"
      else if data = #date(ano, 11, 15) then
        "Proclamação da República"
      else if data = #date(ano, 12, 25) then
        "Natal"
      else if data = sextaFeiraSanta then
        "Sexta-feira Santa"
      else if data = pascoa then
        "Páscoa"
      else if data = segundaCarnaval then
        "Segunda-feira de Carnaval"
      else if data = tercaCarnaval then
        "Terça-feira de Carnaval"
      else if data = corpusChristi then
        "Corpus Christi"
      else
        "", 
  // Adiciona coluna feriado (Sim/Não)
  #"Feriado Adicionado" = Table.AddColumn(
    #"Coluna Condicional Adicionada", 
    "dData_É Feriado", 
    each if EhFeriado([dData_Data]) then "Sim" else "Não", 
    type text
  ), 
  // Adiciona Nome do Feriado
  #"Nome Feriado Adicionado" = Table.AddColumn(
    #"Feriado Adicionado", 
    "dData_Nome Feriado", 
    each NomeFeriado([dData_Data]), 
    type text
  ), 
  // Adiciona se é fim de semana
  #"Fim de Semana Adicionado" = Table.AddColumn(
    #"Nome Feriado Adicionado", 
    "dData_Fim de Semana", 
    each if Date.DayOfWeek([dData_Data], Day.Monday) >= 5 then "Sim" else "Não", 
    type text
  ), 
  // adiciona dia útil
  #"Dia Útil Adicionado" = Table.AddColumn(
    #"Fim de Semana Adicionado", 
    "dData_Tipo Dia", 
    each 
      if [dData_É Feriado] = "Sim" then
        "Feriado"
      else if [dData_Fim de Semana] = "Sim" then
        "Fim de Semana"
      else
        "Dia Útil", 
    type text
  ), 
  // indica um numero booleano para identificar se é ou não dia útil (0 não 1 sim)
  #"Indicador Dia Útil" = Table.AddColumn(
    #"Dia Útil Adicionado", 
    "dData_É Dia Útil", 
    each if [dData_Tipo Dia] = "Dia Útil" then 1 else 0, 
    Int64.Type
  ), 
  #"Tipo Alterado" = Table.TransformColumnTypes(
    #"Indicador Dia Útil", 
    {{"dData_Semana_Mês_Nome", type text}}
  )
in
  #"Tipo Alterado"
