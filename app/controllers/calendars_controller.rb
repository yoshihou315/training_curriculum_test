class CalendarsController < ApplicationController

  def index
    get_week
    @plan = Plan.new
  end

  def create
    @plan = Plan.new(plan_params)
    if @plan.save
      redirect_to action: :index
    else
      get_week
      render :index
    end
  end

  private

  def plan_params
    params.require(:plan).permit(:date, :plan)
  end

  def get_week
    wdays = ['(日)', '(月)', '(火)', '(水)', '(木)', '(金)', '(土)']

    @todays_date = Date.today
    @week_days = []

    plans = Plan.where(date: @todays_date..@todays_date + 6)

    7.times do |x|
      today_plans = []
      plans.each do |plan|
        today_plans.push(plan.plan) if plan.date == @todays_date + x
      end

      wday_num = (@todays_date.wday + x) % 7  # 曜日を0から6の範囲にする

      days = { 
        month: (@todays_date + x).month, 
        date: (@todays_date + x).day, 
        wday: wdays[wday_num],  # 曜日を追加
        plans: today_plans 
      }

      @week_days.push(days)
    end
  end
end