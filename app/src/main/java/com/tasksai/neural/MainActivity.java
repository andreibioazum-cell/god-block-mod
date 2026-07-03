package com.tasksai.neural;
import android.app.Activity;
import android.os.Bundle;
import android.view.Gravity;
import android.widget.*;
import android.graphics.Color;

public class MainActivity extends Activity {
    static { System.loadLibrary("native-lib"); }
    public native String processWithAI(float val);

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        
        LinearLayout root = new LinearLayout(this);
        root.setOrientation(LinearLayout.VERTICAL);
        root.setPadding(60, 100, 60, 60);
        root.setBackgroundColor(0xFF0D1117);
        root.setGravity(Gravity.CENTER_HORIZONTAL);

        TextView tv = new TextView(this);
        tv.setText("TasksAI Smart Guess");
        tv.setTextColor(0xFF58A6FF);
        tv.setTextSize(28);
        root.addView(tv);

        EditText ed = new EditText(this);
        ed.setHint("Input value...");
        ed.setHintTextColor(0xFF484F58);
        ed.setTextColor(Color.WHITE);
        root.addView(ed);

        Button btn = new Button(this);
        btn.setText("THINK WITH NEURAL CORE");
        btn.setPadding(0, 40, 0, 40);
        root.addView(btn);

        TextView out = new TextView(this);
        out.setTextColor(0xFFC9D1D9);
        out.setPadding(0, 50, 0, 0);
        root.addView(out);

        btn.setOnClickListener(v -> {
            try {
                float vIn = Float.parseFloat(ed.getText().toString());
                out.setText(processWithAI(vIn));
            } catch(Exception e) { out.setText("Enter valid number"); }
        });

        setContentView(root);
    }
}
