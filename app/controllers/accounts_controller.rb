class AccountsController < ApplicationController
  before_action :validate_operation_params, only: [:deposit, :withdraw]

  def balance
    render json: AccountsService.balance(params[:id])
  end

  def deposit
    AccountsService.deposit(params[:id], params[:amount])
    render status: :ok
  rescue => e
    render json: { error: e.message }, status: :bad_request
  end

  def withdraw
    AccountsService.withdraw(params[:id], params[:amount])
    render status: :ok
  rescue => e
    render json: { error: e.message }, status: :bad_request
  end

  def transactions
    render json: AccountsService.transactions(params[:id])
  end

  private

  def validate_operation_params
    unless params[:amount].present?
      render json: { error: "Amount parameter is required" }, status: :bad_request
    end
  end
end
