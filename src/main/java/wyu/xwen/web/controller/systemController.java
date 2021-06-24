package wyu.xwen.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/web/system")
public class systemController {

    /*跳转到登录页面*/
    @RequestMapping("toLogin.do")
    public String toLogin(){
        return "login";
    }

    /*跳转到工作台首页*/
    @RequestMapping("toWorkBench.do")
    public  String toWorkBench(){return "workbench/index";}

    /*跳转到activity*/
    @RequestMapping("toActivity.do")
    public  String toActivity(){return "workbench/activity/index";}

    /*workbench/clue/index*/
    @RequestMapping("toClue.do")
    public  String toClue(){return "workbench/clue/index";}

    /*workbench/customer/index.jsp*/
    @RequestMapping("toCustomer.do")
    public  String toCustomer(){return "workbench/customer/index";}

    /*workbench/contacts/index.jsp*/
    @RequestMapping("toContacts.do")
    public  String Contacts(){return "workbench/contacts/index";}

    /*workbench/transaction/index.jsp*/
    @RequestMapping("toTransaction.do")
    public  String toTransaction(){return "workbench/transaction/index";}

}
