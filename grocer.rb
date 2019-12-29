# Thanks for limiting the amount of comments within the file.

def find_item_by_name_in_collection(name, collection)
  
  collection.each {|unit|
    # return matching Hash if desired name and hash[:item] is found.
    
    if unit[:item] == name
      return unit
    end
    
    
  }
  
  # if no match is found then nothing to return
  return nil
  
end



def consolidate_cart(cart) # cart => AoH , Array of Hashes
  
  new_cart = [ ]
  
  cart.each { |i|
    name = i[:item]
    unit = find_item_by_name_in_collection(name, new_cart)
   
   if unit # true || item_name is found then
     
     i[:count] += 1
     
   else
     
     i[:count] = 1
     new_cart.push(i)
     
   end
  
  }
  
  new_cart
  
end

def coupons_hash(cartx)
  # the price of each unit/item should be handled up to two decimal points
  unit_price = (cartx[:cost].to_i * 1.0 / cartx[:num]).round(2)
  
  applied = {:item => "#{cartx[:item]} W/COUPON", :price => unit_price, :count => cartx[:num] }
  
  return applied
  
end

def apply_coupons(cart, coupons)
  
  coupons.each { |coupon|
  
    name = coupon[:item]
    item_with_coupon = find_item_by_name_in_collection(name, cart)
    item_in_cart = !!item_with_coupon
    enough_items = item_in_cart && item_with_coupon[:count] >= coupon[:num]

    if item_in_cart && enough_items
      
      item_with_coupon[:count] -= coupon[:num]
      coupon_item = coupons_hash(coupon)
      coupon_item[:clearance] = item_with_coupon[:clearance]
      cart.push(coupon_item)
      
    end
   
  }

  return cart
  
end

def apply_clearance(cart)
  # REMEMBER: This method *should* update cart
  idx = 0 
  
  while idx < cart.length
    
    item = cart[idx]
    clearance = item[:clearance]
    
    if clearance
      
      discounted_item = ((1 - 0.20 )* item[:price]).round(2) # round it up to two decimal points
      item[:price] = discounted_item # the price of the item with a price discount of 20% == 0.20
      
    end
    
    idx += 1
  
  end
  
  return cart
  
end

def checkout(cart, coupons)
  # This method should call
  # 1st consolidate_cart
  # 2nd apply_coupons
  # 3rd apply_clearance
  
  total_checkout = 0
  idx = 0
  
  cons_cart =  consolidate_cart(cart)
  apply_coupons(cons_cart, coupons)
  
  apply_clearance(cons_cart)


  while idx < cons_cart.length
    
    total_checkout += cons_cart[i][:price] cons_cart[i][:count]
    
    idx += 1
  end
  
  if total_checkout >= 100
    return (total_checkout * 0.9) # 1 - 0.10 or 0.1 , 10% off
  else
    return total_checkout
  end
  
end
