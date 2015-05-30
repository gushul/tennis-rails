class Dashboard::Coach::CoachProfileController < DashboardController
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
    params.require(:coach).permit(:name, :password, :password_confirmation, :email, :price, :avatar, court_ids: [])
  end
end