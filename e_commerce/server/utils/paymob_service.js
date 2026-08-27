export const createPaymobIntention = async ({
  amount,
  orderId,
  user,
  items,
}) => {
  try {
    const nameParts = user.name.trim().split(" ");

    const firstName = nameParts[0];
    const lastName = nameParts.slice(1).join(" ") || "Customer";
    const response = await fetch(
      `${process.env.PAYMOB_API_URL}/v1/intention/`,
      {
        method: "POST",

        headers: {
          Authorization: `Token ${process.env.PAYMOB_SECRET_KEY}`,
          "Content-Type": "application/json",
        },

        body: JSON.stringify({
          amount,
          currency: "EGP",

          payment_methods: [Number(process.env.PAYMOB_INTEGRATION_ID)],

          items,

          billing_data: {
            first_name: firstName,
            last_name: lastName,
            email: user.email,
            phone_number: user.phone,

            apartment: "NA",
            floor: "NA",
            street: "NA",
            building: "NA",
            shipping_method: "NA",
            postal_code: "NA",
            city: "Cairo",
            state: "Cairo",
            country: "EG",
          },

          customer: {
            first_name: firstName,
            last_name: lastName,
            email: user.email,
          },

          // This is what shows up as transaction.order.merchant_order_id
          // in the webhook payload — must be your own Mongo order id.
          special_reference: orderId,

          // Keep this too as a fallback / for any custom metadata you want.
          extras: {
            order_id: orderId,
          },
        }),
      },
    );

    const data = await response.json();

    if (!response.ok) {
      throw new Error(
        data.detail || data.message || "Paymob intention creation failed",
      );
    }

    return data;
  } catch (error) {
    throw error;
  }
};
