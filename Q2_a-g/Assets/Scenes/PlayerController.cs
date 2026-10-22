using UnityEngine;

public class PlayerController : MonoBehaviour
{

    public float speed = 10f;
    public float jumpForce = 7f;

    private Rigidbody rb;
    private bool gameStarted = false;

    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {

        rb = GetComponent<Rigidbody>();

        //Keep the ball still until Start is pressed.
        rb.useGravity = false;
        rb.linearVelocity = Vector3.zero;
        rb.angularVelocity = Vector3.zero;

    }

    void Update()
    {
        //Jump only after the game starts and while grounded.
        if (gameStarted && Input.GetButtonDown("Jump") && IsGrounded()) {
           rb.AddForce(
               Vector3.up * jumpForce,
               ForceMode.Impulse
               );
        }
    }

    // Update is called once per frame
    void FixedUpdate()
    {

        //Do not allow movement before the game starts.
        if (!gameStarted)
        {
            return;
        }

        float moveHorizontal = Input.GetAxis("Horizontal");
        float moveVertical = Input.GetAxis("Vertical");

        Vector3 movement = new Vector3(
            moveHorizontal,
            0.0f,
            moveVertical

            );

        rb.AddForce(movement * speed);

    }

    private bool IsGrounded()
    {
        return Physics.Raycast(
            transform.position,
            Vector3.down,
            0.6f
            );
    }

    public void StartGame()
    {
        gameStarted = true;
        rb.useGravity = true;

        GameObject startButton = GameObject.Find("Start");
        startButton.SetActive(false);
    }
}
