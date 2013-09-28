class Build < ActiveRecord::Base

  include ActionView::Helpers::DateHelper

  belongs_to :project
  validates_presence_of :project_id, :branch

  def ci_command
    "script/cibuild"
  end

  def duration
    unless started_at.nil?
      unless completed_at.nil?
        total_seconds = Integer(completed_at - started_at)
        hours = total_seconds / (60 * 60)
        minutes = (total_seconds / 60) % 60
        seconds = total_seconds % 60

        hours_output = hours > 0 ? "#{hours} hours" : ""
        hours_output << ", " if hours > 0 && minutes > 0

        minutes_output = minutes > 0 ? "#{minutes} minutes" : ""
        minutes_output << ", " if minutes > 0 && seconds > 0

        seconds_output = seconds > 0 ? "#{seconds} seconds" : ""

        output = hours_output + minutes_output + seconds_output
        # distance_of_time_in_words(started_at, completed_at, true)
      else
        "Unfinished"
      end
    else
      "Never started"
    end
  end

  def status_phrase
    case status
    when :succeeded, :failed
      d = duration
      if d.blank?
        "#{status_word} instantly"
      else
        "#{status_word} in #{duration}"
      end
    when :pending
      "Build started #{distance_of_time_in_words_to_now(started_at, :include_seconds => true)} ago"
    when :mia
      "Missing, presumed dead"
    when :queued
      "#{status_word} #{distance_of_time_in_words_to_now(created_at, :include_seconds => true)} ago"
    end


    # unless started_at.nil?
    #   unless completed_at.nil?
    #     d = duration
    #     if d.blank?
    #       "#{status_word} instantly"
    #     else
    #       "#{status_word} in #{duration}"
    #     end
    #   else
    #     "Build started #{distance_of_time_in_words_to_now(started_at, true)} ago"
    #   end
    # else
    #   "#{status_word} #{distance_of_time_in_words_to_now(created_at, true)} ago"
    # end
  end

  def status_word
    status.to_s.titleize
  end

  def status
    unless started_at.nil?
      unless completed_at.nil?
        successful ? :succeeded : :failed
      else
        ages_ago(started_at) ? :mia : :pending
      end
    else
      ages_ago(created_at) ? :mia : :queued
    end
  end

  def ages_ago(time)
    (Time.now - time) > 1.hour
  end

  def mark_status_on_github_as(state)
    CommitStatus.mark(self.project.repo, self.sha, state)
  end

end
