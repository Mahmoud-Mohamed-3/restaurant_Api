# app/models/reservation.rb

class Reservation < ApplicationRecord
  belongs_to :table
  belongs_to :user

  # Check if the table is available during the requested time slot
  def self.check_availability(booked_from, booked_to, table_id)
    # Check for overlapping reservations for the table
    conflicting_reservations = Reservation.where("table_id = ? AND (booked_from, booked_to) OVERLAPS (?, ?)",
                                                 table_id, booked_from, booked_to)

    conflicting_reservations.empty?
  end

  def table_name
    table.table_name
  end
  def num_of_seats
    table.num_of_seats
  end
end
