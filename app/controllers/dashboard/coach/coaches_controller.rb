class Dashboard::Coach::CoachesController < DashboardController
  before_filter :find_coach

  def edit
  end

  def update
    @coach.update coach_params

    render :edit
  end

  private
  def find_coach
    @coach = current_user
  end
  def coach_params
    params.require(:coach).permit(:name, :password, :password_confirmation, :email, :price, :phone, :avatar, court_ids: [], coach_profile_attributes: [:description])
  end
end