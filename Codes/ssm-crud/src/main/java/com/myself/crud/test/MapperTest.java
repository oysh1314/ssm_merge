package com.myself.crud.test;

import com.myself.crud.bean.Department;
import com.myself.crud.bean.Employee;
import com.myself.crud.dao.DepartmentMapper;
import com.myself.crud.dao.EmployeeMapper;
import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.UUID;

/**
 * @author lzq
 * @create 2020-07-28 11:46
 *
 * 测试Dao接口里的方法能否达到我们的预期！
 *
 * 推荐Spring项目使用Spring的单元测试，因为可以自动注入我们需要的组件。
 *  1、导入Spring单元测试模块：<artifactId>spring-test</artifactId>
 *  2、@ContextConfiguration指定Spring配置文件位置；
 *  3、直接autowired要使用的组件即可！
 */
@RunWith(SpringJUnit4ClassRunner.class)  // 使用Spring的测试驱动，而不再是默认的junit
@ContextConfiguration(locations = {"classpath:applicationContext.xml"})  // 注意path的'p'是小写
public class MapperTest {

    // 直接autowired要使用的组件
    @Autowired
    DepartmentMapper departmentMapper;
    @Autowired
    EmployeeMapper employeeMapper;
    @Autowired
    SqlSession sqlSession;
    // 在配置那里定义成了可以批量操作的sqlSession，通过这个sqlSession获取的mapper可以批量操作；
    // 若是默认的获取mapper，则不是批量操作！

    /**
     * 测试DepartmentMapper接口
     */
    @Test
    public void testCRUD(){
        // 一、不使用Spring单元测试时，需要手动创建ioc，并获取mapper
        /*
        // 1、初始化Spring的IOC容器
        ApplicationContext applicationContext = new ClassPathXmlApplicationContext("applicationContext.xml");
        // 2、从容器中获取Dao接口的SQL映射器mapper
        DepartmentMapper mapper = applicationContext.getBean(DepartmentMapper.class);
        */

        // 二、使用Spring单元测试后，可直接使用mapper（注意先autowired）
        //System.out.println(departmentMapper);

        // 插入几个部门
/*        departmentMapper.insertSelective(new Department(null,"开发部"));
        departmentMapper.insertSelective(new Department(null,"测试部"));
        System.out.println("插入成功...");*/

        // 插入员工数据
        // gender类型：数据库字段是char，对象属性是String（底层会自动转换的，所以不需要考虑类型问题！）
/*        employeeMapper.insert(new Employee(null,"Jerry","M","jerry@myself.com",1));
        System.out.println("插入成功...");*/

        // 批量插入员工数据
        /*
            拓展：因为sqlSession在项目中可能会多次使用，所以可以直接在ioc容器中注册，然后直接拿到；
                并且注册时还可以设置为批量操作的sqlSession，
                默认的sqlSession拿到的mapper不会执行批量操作，需要设置。
         */

        // 直接一个for循环插入，则不是批量插入，而是一个个的插入，效率会很低；
/*        for (int i = 0; i < 1000; i++) {
            employeeMapper.insertSelective(new Employee(null,"Jerry","M","jerry@myself.com",1));
        }*/

        // 通过我们配置了批量操作的sqlSession获取的mapper使用for循环插入，才是批量操作！（sqlSession注册后，还需要autowired才能直接使用）
        EmployeeMapper mapper = sqlSession.getMapper(EmployeeMapper.class);
        for (int i = 0; i < 1000; i++) {
            // 随机生成字符作为员工姓名插入
            String uid = UUID.randomUUID().toString().substring(0, 5) + i;
            mapper.insertSelective(new Employee(null,uid,"M",uid+"@myself.com",1));
        }
        System.out.println("批量插入成功...");
        // 另外：不知是电脑性能问题还是没有配置批量成功的原因，用了2分钟左右才将1000条记录插入成功！
    }
}
