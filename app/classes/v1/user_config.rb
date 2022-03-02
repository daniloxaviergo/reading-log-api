class V1::UserConfig

  def get
    OpenStruct.new(
      per_extimativa: 0.1,

      # project status
      em_andamento_range: 8, # dias
      dormindo_range: 16,
      parado_range: 90, # nao utilizado

      # estimavias
      paginas_1_days: 40,
      paginas_7_days: 280,
      paginas_15_days: 600,
      paginas_30_days: 1200,
      paginas_90_days: 3600,

      #
      pages_per_day: 40,

      # máximo de faltas a cada 30 dias
      max_faltas: 3
    )
  end
end
