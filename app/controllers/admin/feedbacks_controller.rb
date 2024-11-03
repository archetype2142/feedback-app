# frozen_string_literal: true

class Admin::FeedbacksController < Admin::BaseController
  def index
    @q = Feedback.ransack(params[:q])
    @feedbacks = @q.result.page(params[:page])
  end

  def update
    @feedback = Feedback.find(params[:id])
    if @feedback.update(feedback_params)
      redirect_to(admin_feedbacks_path, notice: 'Feedback updated successfully')
    else
      redirect_to(admin_feedbacks_path, alert: 'Failed to update feedback')
    end
  end

  private

  def feedback_params
    params.require(:feedback).permit(:status)
  end
end
