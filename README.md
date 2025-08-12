📅 Tabela de Calendário - Power Query M
Uma função completa em Power Query M para criar uma tabela de calendário (dimensão tempo) com feriados brasileiros, indicadores de dias úteis e diversas colunas auxiliares para análises temporais.
🚀 Funcionalidades
Geração Automática de Datas

*Período:\*\* Três anos (ano atual - 2 até ano atual)
*Atualização Dinâmica:** Baseado no ano atual do sistema
\*Cobertura Completa:** Todos os dias do período especificado

Colunas Geradas
📊 Informações Básicas

**dData_Data:** Data completa
**dData_Ano:** Ano (numérico)
**dData_Mês:** Mês (numérico)
**dData_Nome do Mês:** Nome completo do mês
**dData_Mês Abreviado:** Mês abreviado (3 caracteres)
**dData_Dia:** Dia do mês
**dData_Nome do Dia:** Nome completo do dia da semana
**dData_Dia da Semana Abreviado:** Dia da semana abreviado (3 caracteres)

📈 Agrupamentos Temporais

**dData_Trimestre Ano:** Trimestre formatado (ex:** "1ºTri-24")
**dData_Semana do Ano:** Número da semana no ano
**dData_Semana do Mês:** Número da semana no mês
**dData_Semana_Mês_Nome:\*\* Nome formatado da semana ("1º - Sem", "2º - Sem", etc.)

🎉 Feriados Brasileiros

**dData_É Feriado:** Indicador "Sim"/"Não"
**dData_Nome Feriado:** Nome do feriado (quando aplicável)

**Feriados Incluídos:**
**Feriados Fixos:**

--Confraternização Universal (1º de Janeiro)
--Tiradentes (21 de Abril)
--Dia do Trabalhador (1º de Maio)
--Independência do Brasil (7 de Setembro)
--Nossa Senhora Aparecida (12 de Outubro)
--Finados (2 de Novembro)
--Proclamação da República (15 de Novembro)
--Natal (25 de Dezembro)

Feriados Móveis (Calculados pela Fórmula de Gauss):\*\*

Páscoa
Sexta-feira Santa
Segunda-feira de Carnaval
Terça-feira de Carnaval
Corpus Christi

💼 Indicadores de Dias Úteis

--**dData_Fim de Semana:** Indicador "Sim"/"Não" para sábados e domingos
--**dData_Tipo Dia:** Classificação ("Dia Útil", "Fim de Semana", "Feriado")
--**dData_É Dia Útil:** Indicador numérico (1 = dia útil, 0 = não útil)

📝 Licença
--Este código é disponibilizado gratuitamente para uso em projetos pessoais e comerciais.

🤝 Contribuições
--Sugestões e melhorias são bem-vindas! Abra uma issue ou pull request.

Nota:\*\* Este código foi desenvolvido especificamente para o calendário e feriados brasileiros. Para outros países, será necessário adaptar a lista de feriados e suas regras de cálculo.
