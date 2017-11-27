require 'rails_helper'

RSpec.feature "Admin Orders" do
  before(:each) do
    more_orders
    admin = User.create(first_name: "Mi", last_name: "Le", email: "mi@mi.com", password: "mimi", role: "admin")

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)
  end
  context "As an admin" do
    it "I can see the total number of orders for each status" do
      visit admin_dashboard_index_path

      orders = [@order, @order_2, @order_3, @order_4]

      orders.each do |order|
        expect(page).to have_content(order.id)
        expect(page).to have_content(order.date)
        expect(page).to have_content(order.status.capitalize)
      end
    end
    it "I can see orders filtered by status" do

      visit admin_dashboard_index_path

      click_on("Ordered")

      expect(current_path).to eq(admin_dashboard_index_path)
      expect(page).to have_link(@order.id, order_path(@order))
      expect(page).not_to have_link(@order_2.id)
      expect(page).not_to have_link(@order_3.id)
      expect(page).not_to have_link(@order_4.id)
    end
    it "I can change the status of orders" do
      visit admin_dashboard_index_path

      within(".order-2") do
        click_on("Cancel")
      end

      expect(current_path).to eq(admin_dashboard_index_path)

      within(".order-2") do
        expect(page).to have_content("Cancelled")
      end

      within(".order-1") do
        click_on("Mark as Paid")
      end

      expect(current_path).to eq(admin_dashboard_index_path)

      within(".order-1") do
        within(".status") do
          expect(page).to have_content("Paid")
        end
      end

      within(".order-1") do
        click_on("Mark as Completed")
      end

      expect(current_path).to eq(admin_dashboard_index_path)

      within(".order-1") do
        within(".status") do
          expect(page).to have_content("Completed")
        end
      end

    end
  end
end
