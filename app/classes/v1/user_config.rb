class UserConfig

  def get
    OpenStruct.new(
      per_extimativa: 0.1,

      # project status
      em_andamento_range: 8, # dias
      dormindo_range: 16,
      parado_range: 90, # nao utilizado

      # estimavias
      paginas_7_days: 50,
      paginas_15_days: 100,
      paginas_30_days: 200,
      paginas_90_days: 600,

      #
      pages_per_day: 10
    )
  end
end
