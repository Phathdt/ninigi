class ManagerRequest < ApplicationRecord
  include AASM

  acts_as_paranoid
  enum state: %i[pending approved suspended retired]

  aasm column: 'state', enum: true do
    state :pending, initial: true
    state :approved, :suspended, :retired

    after_all_transitions :send_email_manager_request

    event :approve, after: :add_role do
      transitions from: :pending, to: :approved
    end

    event :reject do
      transitions from: :pending, to: :suspended
    end

    event :repending, after: :remove_comment do
      transitions from: :suspended, to: :pending
      transitions from: :retired, to: :pending
    end

    event :retire, after: :remove_role do
      transitions from: :approved, to: :retired
    end
  end

  belongs_to :restaurant
  belongs_to :manager, class_name: 'User', foreign_key: 'user_id'

  validates_uniqueness_of :restaurant_id, scope: :user_id
  validates :comment, presence: true, if: Proc.new { |req| req.suspended? || req.retired? }

  after_create :send_email_pending

  private

  def remove_comment
    update_attribute('comment', nil)
  end

  def send_email_pending
    SendEmailManagerRequestJob.perform_later(restaurant, manager, 'initial', 'pending', I18n.locale.to_s)
  end

  def send_email_manager_request
    SendEmailManagerRequestJob.perform_later(restaurant, manager, aasm.from_state.to_s, aasm.to_state.to_s, I18n.locale.to_s)
  end

  def add_role
    manager.add_role(:manager) unless manager.has_role?(:manager)
  end

  def remove_role
    manager.remove_role(:manager) unless manager.manager_requests.where(state: :approved).exists?
  end
end
