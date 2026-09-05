// export const createPaymobIntention = async ({
//   amount,
//   orderId,
//   user,
//   items,
// }) => {
//   try {
//     const nameParts = user.name.trim().split(" ");

//     const firstName = nameParts[0];
//     const lastName = nameParts.slice(1).join(" ") || "Customer";
//     const response = await fetch(
//       `${process.env.PAYMOB_API_URL}/v1/intention/`,
//       {
//         method: "POST",

//         headers: {
//           Authorization: `Token ${process.env.PAYMOB_SECRET_KEY}`,
//           "Content-Type": "application/json",
//         },

//         body: JSON.stringify({
//           amount,
//           currency: "EGP",

//           payment_methods: [Number(process.env.PAYMOB_INTEGRATION_ID)],

//           items,

//           billing_data: {
//             first_name: firstName,
//             last_name: lastName,
//             email: user.email,
//             phone_number: user.phone,

//             apartment: "NA",
//             floor: "NA",
//             street: "NA",
//             building: "NA",
//             shipping_method: "NA",
//             postal_code: "NA",
//             city: "Cairo",
//             state: "Cairo",
//             country: "EG",
//           },

//           customer: {
//             first_name: firstName,
//             last_name: lastName,
//             email: user.email,
//           },

//           // This is what shows up as transaction.order.merchant_order_id
//           // in the webhook payload — must be your own Mongo order id.
//           special_reference: orderId,

//           // Keep this too as a fallback / for any custom metadata you want.
//           extras: {
//             order_id: orderId,
//           },
//         }),
//       },
//     );

//     const data = await response.json();

//     if (!response.ok) {
//       throw new Error(
//         data.detail || data.message || "Paymob intention creation failed",
//       );
//     }

//     return data;
//   } catch (error) {
//     throw error;
//   }
// };
/*
 * ============================================================
 * PAYMOB SERVICE
 * ============================================================
 *
 * This file communicates directly with Paymob.
 *
 * The controller should handle our application logic.
 * This file handles Paymob API communication.
 */


/*
 * Create a Paymob payment intention.
 *
 * The intention gives us a client secret that Flutter
 * can use to open the Paymob Unified Checkout.
 */
export const createPaymobIntention =
  async ({
    amount,
    reference,
    user,
    items,
  }) => {

    /*
     * Split the user's name.
     *
     * Paymob billing data requires first_name and last_name.
     */
    const nameParts =
      (user.name || "Customer")
        .trim()
        .split(/\s+/);


    const firstName =
      nameParts[0] ||
      "Customer";


    const lastName =
      nameParts
        .slice(1)
        .join(" ") ||
      "Customer";


    /*
     * Send request to Paymob.
     */
    const response =
      await fetch(
        `${process.env.PAYMOB_API_URL}/v1/intention/`,
        {
          method: "POST",

          headers: {
            /*
             * Secret key MUST stay on backend.
             *
             * Never put PAYMOB_SECRET_KEY inside Flutter.
             */
            Authorization:
              `Token ${process.env.PAYMOB_SECRET_KEY}`,

            "Content-Type":
              "application/json",
          },

          body: JSON.stringify({
            /*
             * Amount is in piastres.
             */
            amount,

            /*
             * Your currency.
             */
            currency: "EGP",

            /*
             * Paymob integration ID.
             */
            payment_methods: [
              Number(
                process.env
                  .PAYMOB_INTEGRATION_ID,
              ),
            ],

            /*
             * Products shown by Paymob.
             */
            items,


            /*
             * Customer billing information.
             */
            billing_data: {
              first_name:
                firstName,

              last_name:
                lastName,

              email:
                user.email,

              phone_number:
                user.phone,

              apartment:
                "NA",

              floor:
                "NA",

              street:
                "NA",

              building:
                "NA",

              shipping_method:
                "NA",

              postal_code:
                "NA",

              city:
                "Cairo",

              state:
                "Cairo",

              country:
                "EG",
            },


            /*
             * Customer information.
             */
            customer: {
              first_name:
                firstName,

              last_name:
                lastName,

              email:
                user.email,
            },


            /*
             * IMPORTANT:
             *
             * We put our PaymentSession ID here.
             *
             * This gives us a reference between:
             *
             * Our database
             *       ↕
             * Paymob
             */
            special_reference:
              reference,


            /*
             * Extra information that can also be used
             * when processing the webhook.
             */
            extras: {
              payment_session_id:
                reference,
            },
          }),
        },
      );


    /*
     * Parse Paymob response.
     */
    const data =
      await response.json();


    /*
     * Paymob returned an error.
     */
    if (!response.ok) {
      throw new Error(
        data.detail ||
          data.message ||
          "Paymob intention creation failed",
      );
    }


    /*
     * Return Paymob response to controller.
     */
    return data;
  };