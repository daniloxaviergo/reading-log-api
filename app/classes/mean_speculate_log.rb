class MeanSpeculateLog
  attr_reader :means, :geral

  def initialize(meanLog)
    @config = UserConfig.new.get

    @means = meanLog.means.to_a.each_with_object({}) do |(wday, mean), obj|
      obj[wday] = calculate(mean)
    end

    @geral = calculate(meanLog.geral)
  end

  def by_wday(wday)
    @means[wday]
  end

  private

  def calculate(mean)
    ((mean.to_f * @config.per_extimativa) + mean.to_f).round(3)
  end
end
