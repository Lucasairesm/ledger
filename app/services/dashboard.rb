class Dashboard
  def initialize(user)
    @user = user
    #@active_people_ids = Person.where(active: true).select(:id) 
# @active_people_ids definimos para conseguir ter a chamada do item,colocaria @ para disponibilizar para ser utilizado.
  end
  
  def active_people_ids 
  Rails.cache.fetch("active_people_ids", expires_in:6.hours) do 
   Person.where(active: true).select(:id)
    end
  end
# Outra maneira de se disponibilizar o @active_people_ids
  
  def active_people_pie_chart 
    Rails.cache.fetch("active_people_pie_chart", expires_in:6.hours) do 
   {
      active: active_people_ids.count,
      #reaproveitando o código (da parte de select) para não fazer 2 consultas.
      inactive: Person.where(active: false).count
    }
    end
  end

  def total_debts  
    Rails.cache.fetch("total_debts", expires_in:6.hours) do 
    Debt.where(person_id: active_people_ids).sum(:amount)
    end
  end
  
  def total_payments
    Rails.cache.fetch("total_payments", expires_in:6.hours) do 
    Payment.where(person_id: @active_people_ids).sum(:amount)  
    end
  end
  
  def balance 
   Rails.cache.fetch("balance", expires_in:6.hours) do 
    self.total_payments - self.total_debts
   end
  end
  
  def last_debts 
    Rails.cache.fetch("last_debts", expires_in:6.hours) do
    Debt.order(created_at: :desc).limit(10).map do |debt|
    [debt.id, debt.amount]
     end
   end
  end

  def last_payments 
    Rails.cache.fetch("last_payments", expires_in:6.hours) do 
     Payment.order(created_at: :desc).limit(10).map do |payment|
    [payment.id, payment.amount]
      end
    end
  end

  def my_people  
    # Rails.cache.fetch("my_people", expires_in:6.hours) do 
    # Ela não pode ser cacheada se não um segundo usuario ira poder ter acesso 
    Person.where(user: @user).order(:created_at).limit(10)
    # end #Este "end" seria o que fecharia o "do" do cacheamento kk.
  end
  
  def top_person 
    Rails.cache.fetch("top_person", expires_in:6.hours) do 
      Person.order(:balance).last
    end
  end

  def bottom_person 
    Rails.cache.fetch("bottom_person", expires_in:6.hours) do 
     Person.order(:balance).first
    end
  end

end
