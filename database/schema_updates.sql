CREATE OR REPLACE FUNCTION handle_booking_payment(booking_id UUID)
RETURNS VOID AS $$
DECLARE
    target_room_id UUID;
    target_hostel_name TEXT;
    target_room_number TEXT;
    target_amount INT;
    target_student_id UUID;
BEGIN
    -- Get booking details
    SELECT b.room_id, b.amount, b.student_id INTO target_room_id, target_amount, target_student_id
    FROM bookings b
    WHERE b.id = booking_id;
    
    -- Get room/hostel details
    SELECT r.room_number, h.name INTO target_room_number, target_hostel_name
    FROM rooms r
    JOIN hostels h ON r.hostel_id = h.id
    WHERE r.id = target_room_id;

    -- Update booking status
    UPDATE bookings
    SET status = 'paid'
    WHERE id = booking_id;

    -- Insert into payments
    INSERT INTO payments (transaction_id, hostel_name, room_number, amount, method, status)
    VALUES (booking_id::TEXT, target_hostel_name, target_room_number, target_amount, 'Simulated', 'completed');

    -- Update room occupancy
    UPDATE rooms
    SET current_occupancy = current_occupancy + 1,
        is_available = CASE 
            WHEN (current_occupancy + 1) >= max_occupancy THEN FALSE 
            ELSE is_available 
        END
    WHERE id = target_room_id;
END;
$$ LANGUAGE plpgsql;
