package wyu.xwen.handler;

import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.ModelAndView;
import wyu.xwen.exception.ActivityDeleteException;

@ControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(value = ActivityDeleteException.class)
    public ModelAndView activityDelete(){
        return null;
    }
}
